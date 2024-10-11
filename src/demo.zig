//  Table of Contents
//
//  Setup Phase         -0103
//  Unit Printing       -0261
//  Playing the Game    -0337
//      Remembering     -0547
//      Sandboxing      -0616
//      Commands        -0739
//      Retreats        -0983
//      Builds          -1084

const std = @import("std");
const classic = @import("classic.zig");
const dip = @import("dip.zig");
const dip_names = @import("dip_names.zig");
const dip_memory = @import("dip_memory.zig");

const Reader = std.io.AnyReader;
const Writer = std.io.AnyWriter;
const Options = dip.GameOptions;
const Country = dip.Country;
const Province = dip.Province;
const Game = dip.Game;
const Names = dip_names.NamesData;
const Memory = dip_memory.Memory;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const reader = std.io.getStdIn().reader().any();
    const writer = std.io.getStdOut().writer().any();

    var game, const names = try setupPhase(allocator, reader, writer);
    var memory = try Memory.init(allocator, classic.start_year);
    try playGame(&game, names, &memory, reader, writer);
}

/// Returns a struct with `parse` function that return a tuple of objects with types from `types`.
/// If there is only one type, returns it instead of tuple of 1 element.
/// See example usage.
fn Parser(types: []const type, start: ?[]const u8, delimeters: []const []const u8, end: ?[]const u8) type {
    const n: comptime_int = types.len;
    if (delimeters.len != n - 1) @compileError("Wrong number of delimeters");

    const OutType = if (n == 1) types[0] else blk: {
        comptime var out_fields: [n]std.builtin.Type.StructField = undefined;
        inline for (types, 0..) |T, i| {
            out_fields[i] = .{
                .name = std.fmt.comptimePrint("{d}", .{i}),
                .type = T,
                .default_value = null,
                .is_comptime = false,
                .alignment = @alignOf(T),
            };
        }
        const out_type_info = std.builtin.Type{
            .Struct = .{
                .layout = .auto,
                .fields = &out_fields,
                .decls = &.{},
                .is_tuple = true,
            },
        };
        break :blk @Type(out_type_info);
    };
    return struct {
        fn parseName(comptime T: type, names: Names, name: []const u8) dip_names.UnknownName!T {
            const text = std.mem.trim(u8, name, " ");
            return switch (T) {
                Country => try names.countryByName(text),
                Province => try names.provinceByName(text),
                else => @compileError("unreachable"),
            };
        }

        const ParseError = dip_names.UnknownName || error{CantParse};

        fn parse(names: Names, input: []const u8) ParseError!OutType {
            var out: OutType = undefined;
            var text = std.mem.trim(u8, input, " ");
            if (start) |s| {
                if (std.mem.startsWith(u8, text, s)) text = text[s.len..] else return error.CantParse;
            }
            if (end) |e| {
                if (std.mem.endsWith(u8, text, e)) text = text[0..(text.len - e.len)] else return error.CantParse;
            }
            inline for (delimeters, 0..) |delim, idx| {
                const i = std.mem.indexOf(u8, text, delim) orelse return error.CantParse;
                const value = text[0..i];
                out[idx] = try parseName(types[idx], names, value);
                text = text[i + delim.len ..];
            }
            if (n == 1) return try parseName(OutType, names, text);
            out[n - 1] = try parseName(types[n - 1], names, text);
            return out;
        }
    };
}

//  |---------------|
//--|  Setup Phase  |
//  |---------------|

const Variant = enum { Classic, AvsF };

fn setupPhase(allocator: std.mem.Allocator, reader: Reader, writer: Writer) !dip_names.GameAndNames {
    var options: Options = .{};
    var variant: Variant = .Classic;
    var buffer: [256]u8 = undefined;
    try setupHelp(writer);
    while (true) {
        try writer.print("\n>", .{});
        const raw_input = try reader.readUntilDelimiter(&buffer, '\n');
        const input = std.mem.trimRight(u8, raw_input, "\r");
        var iter = std.mem.splitScalar(u8, input, ' ');
        const command = iter.next() orelse continue;
        if (std.mem.eql(u8, command, ".help")) {
            try setupHelp(writer);
        } else if (std.mem.eql(u8, command, ".variants")) {
            try viewVariants(writer);
        } else if (std.mem.eql(u8, command, ".current")) {
            try printVariant(variant, writer);
        } else if (std.mem.eql(u8, command, ".select")) {
            try selectVariant(&variant, iter.rest(), writer);
            try printVariant(variant, writer);
        } else if (std.mem.eql(u8, command, ".options")) {
            try printOptions(options, writer);
        } else if (std.mem.eql(u8, command, ".info")) {
            try printOptionInfo(iter.rest(), writer);
        } else if (std.mem.eql(u8, command, ".set")) {
            const name = iter.next() orelse continue;
            const value = iter.next() orelse continue;
            try setOption(&options, name, value, writer);
        } else if (std.mem.eql(u8, command, ".start")) {
            switch (variant) {
                .Classic => {
                    var game, const names = try classic.classicGame(allocator);
                    game.options = options;
                    return .{ game, names };
                },
                .AvsF => {
                    var game, const names = try classic.avsfGame(allocator);
                    game.options = options;
                    return .{ game, names };
                },
            }
        } else if (command.len > 0) {
            try writer.print("Invalid command: \"{s}\". Type \".help\" for all possible commands.\n", .{command});
        }
    }
}

fn optionDescription(name: []const u8) []const u8 {
    if (std.mem.eql(u8, name, "missing_orders")) return "How to deal with missing orders.";
    if (std.mem.eql(u8, name, "illegal_commands")) return "How to deal with illegal orders during move phase.";
    if (std.mem.eql(u8, name, "illegal_retreats")) return "How to deal with illegal orders during retreat phase.";
    if (std.mem.eql(u8, name, "duplicate_orders")) return "How to treat repeated orders to same unit/province.";
    if (std.mem.eql(u8, name, "extra_builds")) return "How to handle more build/disband orders than possible.";
    if (std.mem.eql(u8, name, "adapt_area")) return "How to adapt land<->coast provinces in orders.\nOn \"adapt\" F Mar - Spa turns into F Mar(c) - Spa(sc).\nOn \"adapt_across_coasts\" F Mar - Spa(nc) turns into F Mar(c) - Spa(sc).";
    if (std.mem.eql(u8, name, "move_to_convoy")) return "When to substitute move for move via convoy.";
    if (std.mem.eql(u8, name, "move_to_self_is_hold")) return "Whether to substitute X - X in moves and supports into X holds and support holds.";
    if (std.mem.eql(u8, name, "infer_convoy_intent")) return "Whether to convert legal move to move via convoy if there is a legal transport order from same power.";
    if (std.mem.eql(u8, name, "convoy_can_fallback")) return "Whether convoy move can use land route when convoy is cancelled.";
    unreachable;
}

fn setupHelp(writer: Writer) !void {
    try writer.print(".help                 - See this.\n", .{});
    try writer.print(".variants             - Print available variants.\n", .{});
    try writer.print(".current              - Print currently selected variant.\n", .{});
    try writer.print(".select <name>        - Select a variant to play.\n", .{});
    try writer.print(".options              - Print current game options.\n", .{});
    try writer.print(".info <option>        - See more information about option.\n", .{});
    try writer.print(".set <option> <value> - Set an option to a given value.\n", .{});
    try writer.print(".start                - Starts the game with selected options.\n", .{});
}

fn viewVariants(writer: Writer) !void {
    inline for (std.meta.fields(Variant)) |field| {
        try writer.print("{s}\n", .{field.name});
    }
}

fn printVariant(variant: Variant, writer: Writer) !void {
    try writer.print("Current variant is : \"{s}\"\n", .{@tagName(variant)});
}

fn selectVariant(variant: *Variant, name: []const u8, writer: Writer) !void {
    if (std.meta.stringToEnum(Variant, name)) |v| {
        variant.* = v;
    } else try writer.print("Invalid variant: \"{s}\"\n", .{name});
}

fn printOptions(options: Options, writer: Writer) !void {
    inline for (std.meta.fields(Options)) |field| {
        const value = @field(options, field.name);
        switch (@typeInfo(@TypeOf(value))) {
            .Enum => try writer.print("{s: <25} = {s}\n", .{ field.name, @tagName(value) }),
            .Bool => try writer.print("{s: <25} = {any}\n", .{ field.name, value }),
            else => unreachable,
        }
    }
}

fn printOptionInfo(name: []const u8, writer: Writer) !void {
    inline for (std.meta.fields(Options)) |field| {
        if (std.mem.eql(u8, name, field.name)) {
            try writer.print("{s}\n", .{optionDescription(field.name)});
            try writer.print("Possible values:\n", .{});
            switch (@typeInfo(field.type)) {
                .Enum => |en| {
                    inline for (en.fields) |enum_field| {
                        try writer.print("-{s}\n", .{enum_field.name});
                    }
                    return;
                },
                .Bool => {
                    try writer.print("-true\n-false\n", .{});
                    return;
                },
                else => unreachable,
            }
        }
    }
    try writer.print("Invalid option: \"{s}\"\n", .{name});
}

fn setOption(options: *Options, name: []const u8, value: []const u8, writer: Writer) !void {
    inline for (std.meta.fields(Options)) |field| {
        if (std.mem.eql(u8, name, field.name)) {
            switch (@typeInfo(field.type)) {
                .Enum => {
                    if (std.meta.stringToEnum(field.type, value)) |enum_value| {
                        @field(options, field.name) = enum_value;
                        return;
                    } else {
                        return try writer.print("Invalid value: \"{s}\"\n", .{value});
                    }
                },
                .Bool => {
                    if (std.mem.eql(u8, value, "true")) {
                        @field(options, field.name) = true;
                        return;
                    } else if (std.mem.eql(u8, value, "false")) {
                        @field(options, field.name) = false;
                        return;
                    } else {
                        return try writer.print("Invalid value: \"{s}\"\n", .{value});
                    }
                },
                else => unreachable,
            }
        }
    }
    try writer.print("Invalid option: \"{s}\"\n", .{name});
}

//  |-----------------|
//--|  Unit Printing  |
//  |-----------------|

/// Everything needed to display information about a unit except for province. (Why no province?)
/// Double optional retreat just because I could.
/// Outer null : does not need retreat. Inner null: retreat is not ordered yet.
const UnitInfoForPrint = union(enum) {
    const Order = struct { command: ?dip.Command, status: dip.Status };
    const Retreat = struct { to: ?Province, status: dip.Status };

    move: struct { order: Order, retreat: ??Retreat },
    winter: enum { build, stay, disband },
};

const CliOptions = struct {
    short: bool = false,
};

fn nameOf(names: Names, obj: anytype, cli_options: CliOptions) []const u8 {
    if (cli_options.short) return names.shortNameOf(obj) else return names.fullNameOf(obj);
}

fn printCommand(command: dip.Command, names: Names, writer: Writer, cli_options: CliOptions) !void {
    switch (command) {
        .hold => try writer.print(" h", .{}),
        .move => |m| try writer.print(" - {s}", .{nameOf(names, m.to, cli_options)}),
        .convoy_move => |cm| try writer.print(" c- {s}", .{nameOf(names, cm.to, cli_options)}),
        .support_hold => |sh| try writer.print(" s {s} h", .{nameOf(names, sh.at, cli_options)}),
        .support_move => |sm| try writer.print(" s {s} - {s}", .{ nameOf(names, sm.from, cli_options), nameOf(names, sm.to, cli_options) }),
        .convoy_transport => |ct| try writer.print(" c {s} - {s}", .{ nameOf(names, ct.from, cli_options), nameOf(names, ct.to, cli_options) }),
    }
}

fn printUnit(province: Province, info: UnitInfoForPrint, names: Names, writer: Writer, cli_options: CliOptions) !void {
    switch (info) {
        .move => |m| {
            try writer.print("{s: <10}", .{if (m.retreat) |_| "Dislodged" else ""});
        },
        .winter => |w| try writer.print("{s: <10}", .{switch (w) {
            .build => "Build",
            .stay => "",
            .disband => "Disband",
        }}),
    }

    if (province == .land) try writer.print("A ", .{}) else try writer.print("F ", .{});
    try writer.print("{s}", .{nameOf(names, province, cli_options)});

    if (info == .move) {
        if (info.move.order.command) |command| {
            try printCommand(command, names, writer, cli_options);
            switch (info.move.order.status) {
                .unresolved => {},
                .illegal => try writer.print(" [ILLEGAL]", .{}),
                .succeeded => try writer.print(" [SUCCEEDED]", .{}),
                .failed => try writer.print(" [FAILED]", .{}),
            }
        }
        if (info.move.retreat) |dislodged| if (dislodged) |retreat| {
            if (retreat.to) |to| {
                try writer.print("\n{s: <15}(Retreats to {s})", .{ "", nameOf(names, to, cli_options) });
            } else {
                try writer.print("\n{s: <15}(Disbands)", .{""});
            }
            switch (retreat.status) {
                .unresolved => {},
                .illegal => try writer.print(" [ILLEGAL]", .{}),
                .succeeded => try writer.print(" [SURVIVED]", .{}),
                .failed => try writer.print(" [DISBANDED]", .{}),
            }
        };
    }
    try writer.print("\n", .{});
}

//  |--------------------|
//--|  Playing the Game  |
//  |--------------------|

fn playGame(game: *Game, names: Names, memory: *Memory, reader: Reader, writer: Writer) !void {
    var buffer: [256]u8 = undefined;
    var cli_options: CliOptions = .{};
    try writer.print("The game has started.\n", .{});
    try gameHelp(writer);
    while (true) {
        try writer.print("\n>", .{});
        const raw_input = try reader.readUntilDelimiter(&buffer, '\n');
        const input = std.mem.trimRight(u8, raw_input, "\r");
        var iter = std.mem.splitScalar(u8, input, ' ');
        const command = iter.next() orelse continue;
        if (std.mem.eql(u8, command, ".help")) {
            try gameHelp(writer);
        } else if (std.mem.eql(u8, command, ".options")) {
            try printOptions(game.options, writer);
        } else if (std.mem.eql(u8, command, ".season")) {
            try printSeason(game.*, memory.*, writer);
        } else if (std.mem.eql(u8, command, ".sc")) {
            try printSC(game.*, names, writer, cli_options);
        } else if (std.mem.eql(u8, command, ".units")) {
            const country_mb = if (iter.rest().len == 0) null else names.countryByName(iter.rest()) catch {
                try writer.print("Invalid country: \"{s}\"\n", .{iter.rest()});
                continue;
            };
            try printAllUnits(game.*, names, country_mb, writer, cli_options);
        } else if (std.mem.eql(u8, command, ".order")) {
            const country_mb = if (iter.rest().len == 0) null else names.countryByName(iter.rest()) catch {
                try writer.print("Invalid country: \"{s}\"\n", .{iter.rest()});
                continue;
            };
            try takeOrders(game, names, country_mb, reader, writer, cli_options);
        } else if (std.mem.eql(u8, command, ".sandbox")) {
            try takeSandboxOrders(game, names, reader, writer, cli_options);
        } else if (std.mem.eql(u8, command, ".adjudicate")) {
            try adjudicate(game, memory, writer);
            try printSeason(game.*, memory.*, writer);
            try printAllUnits(game.*, names, null, writer, cli_options);
        } else if (std.mem.eql(u8, command, ".remember")) {
            try remember(game.*, names, memory.*, iter.rest(), writer, cli_options);
        } else if (std.mem.eql(u8, command, ".short")) {
            try setShort(&cli_options, iter.rest(), writer);
        } else if (command.len > 0) {
            try writer.print("Invalid command: \"{s}\"\n", .{command});
        }
    }
}

fn gameHelp(writer: Writer) !void {
    try writer.print(".help                     - See this.\n", .{});
    try writer.print(".short <on|off>           - Enable or disable short names mode for printing.\n", .{});
    try writer.print(".options                  - Print current game options.\n", .{});
    try writer.print(".season                   - Print current year and phase.\n", .{});
    try writer.print(".sc                       - Print status of all supply centers.\n", .{});
    try writer.print(".units [country]          - Print all units. Only contry's if given.\n", .{});
    try writer.print(".order [country]          - Start parsing orders. Only for country's units if given.\n", .{});
    try writer.print(".sandbox                  - Start parsing sandbox commands. Resets all orders.\n", .{});
    try writer.print(".adjudicate               - Try to adjudicate current phase and go to next one.\n", .{});
    try writer.print(".remember [year season]   - Print last board state or at a given year and season.\n", .{});
}

fn setShort(cli_options: *CliOptions, input: []const u8, writer: Writer) !void {
    if (std.mem.eql(u8, input, "on")) {
        cli_options.short = true;
        try writer.print("Short names enabled.\n", .{});
    } else if (std.mem.eql(u8, input, "off")) {
        cli_options.short = false;
        try writer.print("Long names enabled.\n", .{});
    } else try writer.print("Expected \"on\" or \"off\", got: \"{s}\"\n", .{input});
}

fn printSeason(game: Game, memory: Memory, writer: Writer) !void {
    try writer.print("{d}", .{memory.currentYear()});
    switch (game.season) {
        .spring => try writer.print(" Spring\n", .{}),
        .spring_retreat => try writer.print(" Spring retreats\n", .{}),
        .fall => try writer.print(" Fall\n", .{}),
        .fall_retreat => try writer.print(" Fall retreats\n", .{}),
        .winter => try writer.print(" Winter\n", .{}),
        else => unreachable,
    }
}

fn printSC(game: Game, names: Names, writer: Writer, cli_options: CliOptions) !void {
    try writer.print("{s: <15} {s: <15} {s: <15}\n", .{ "Province", "Home owner", "Current owner" });
    for (game.supply_centers) |sc| {
        const province = nameOf(names, sc.land, cli_options);
        const home_owner = if (sc.home_owner) |h| nameOf(names, h, cli_options) else "";
        const current_owner = if (sc.owner) |o| nameOf(names, o, cli_options) else "";
        try writer.print("{s: <15} {s: <15} {s: <15}\n", .{ province, home_owner, current_owner });
    }
}

fn printAllUnits(game: Game, names: Names, country_mb: ?Country, writer: Writer, cli_options: CliOptions) !void {
    if (country_mb) |country| {
        try writer.print("\n{s}:\n", .{names.fullNameOf(country)});
        if (game.season.isBuild()) {
            if (game.buildsLeft(country) catch unreachable > 0) try writer.print("{d} builds left.\n", .{game.buildsLeft(country) catch unreachable});
            if (game.disbandsLeft(country) catch unreachable > 0) try writer.print("{d} disbands left.\n", .{game.disbandsLeft(country) catch unreachable});
            for (game.builds.items) |build| {
                const sc = game.scAt(build).?;
                if (!std.meta.eql(country, sc.home_owner.?)) continue;
                try printUnit(build, .{ .winter = .build }, names, writer, cli_options);
            }
            for (game.units.items, 0..) |unit, idx| {
                if (!std.meta.eql(country, unit.country)) continue;
                const info = UnitInfoForPrint{ .winter = if (game.disbandIdxOf(@intCast(idx)) != null) .disband else .stay };
                try printUnit(unit.province, info, names, writer, cli_options);
            }
        } else if (game.season.isMove()) {
            for (game.units.items) |unit| {
                if (!std.meta.eql(country, unit.country)) continue;
                const info = UnitInfoForPrint{
                    .move = .{
                        .order = .{ .command = unit.command, .status = .unresolved },
                        .retreat = null,
                    },
                };
                try printUnit(unit.province, info, names, writer, cli_options);
            }
        } else if (game.season.isRetreat()) {
            for (game.units.items, 0..) |unit, idx| {
                if (!std.meta.eql(country, unit.country)) continue;
                const info = UnitInfoForPrint{
                    .move = .{
                        .order = .{ .command = unit.command, .status = unit.status },
                        .retreat = blk: {
                            if (!(game.shouldRetreat(@intCast(idx)) catch unreachable)) break :blk null;
                            var retreat_info: ?UnitInfoForPrint.Retreat = null;
                            if (game.retreatIdxOf(@intCast(idx))) |retreat_idx| {
                                const retreat = game.retreats.items[retreat_idx];
                                retreat_info = .{ .to = retreat.to, .status = .unresolved };
                            }
                            break :blk retreat_info;
                        },
                    },
                };
                try printUnit(unit.province, info, names, writer, cli_options);
            }
        } else unreachable;
    } else {
        var country_iter = game.countryIterator();
        while (country_iter.next()) |country| {
            try printAllUnits(game, names, country, writer, cli_options);
        }
    }
}

fn takeOrders(game: *Game, names: Names, country_mb: ?Country, reader: Reader, writer: Writer, cli_options: CliOptions) !void {
    switch (game.season) {
        .spring, .fall => try takeMoveOrders(game, names, country_mb, reader, writer, cli_options),
        .spring_retreat, .fall_retreat => try takeRetreatOrders(game, names, country_mb, reader, writer, cli_options),
        .winter => try takeBuildOrders(game, names, country_mb, reader, writer, cli_options),
        else => unreachable,
    }
}

fn adjudicate(game: *Game, memory: *Memory, writer: Writer) !void {
    switch (game.season) {
        .spring => {
            game.adjudicateSpring() catch |err| switch (err) {
                error.NoOrder => return try writer.print("Adjudication failed, not all units recieved orders.\n", .{}),
                error.WrongPhase => unreachable,
            };
            if (game.allRetreatsIssued() catch unreachable) {
                try writer.print("No retreats needed, transitioning to fall.\n", .{});
                try adjudicate(game, memory, writer);
            }
        },
        .fall => {
            game.adjudicateFall() catch |err| switch (err) {
                error.NoOrder => return try writer.print("Adjudication failed, not all units recieved orders.\n", .{}),
                error.WrongPhase => unreachable,
            };
            if (game.allRetreatsIssued() catch unreachable) {
                try writer.print("No retreats needed, transitioning to winter.\n", .{});
                try adjudicate(game, memory, writer);
            }
        },
        .spring_retreat => {
            game.adjudicateSpringRetreats() catch |err| switch (err) {
                error.NoOrder => return try writer.print("Adjudication failed, not all units recieved retreat orders.\n", .{}),
                error.WrongPhase => unreachable,
            };
            try memory.rememberSpring(game);
            game.stepSpring() catch unreachable;
        },
        .fall_retreat => {
            game.adjudicateFallRetreats() catch |err| switch (err) {
                error.NoOrder => return try writer.print("Adjudication failed, not all units recieved retreat orders.\n", .{}),
                error.WrongPhase => unreachable,
            };
            try memory.rememberFall(game);
            game.stepFall() catch unreachable;
        },
        .winter => {
            game.adjudicateWinter() catch |err| switch (err) {
                error.NoOrder => return try writer.print("Adjudication failed, not all disband orders recieved.\n", .{}),
                error.WrongPhase => unreachable,
            };
            try memory.rememberWinter(game);
            game.stepWinter() catch unreachable;
        },
        else => unreachable,
    }
}

//    |---------------|
//----|  Remembering  |
//    |---------------|

fn remember(game: Game, names: Names, memory: Memory, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    if (input.len == 0) {
        if (game.season.isSpring()) {
            if (memory.year_snapshots.items.len == 0)
                return try writer.print("No board state to remember.\n", .{});
            return rememberBuild(game, names, memory.year_snapshots.items[memory.year_snapshots.items.len - 1].winter, writer, cli_options);
        }
        if (game.season.isFall()) return rememberMove(game, names, memory.unfinished_snapshot.spring, writer, cli_options);
        if (game.season.isWinter()) return rememberMove(game, names, memory.unfinished_snapshot.fall, writer, cli_options);
        unreachable;
    } else {
        var iter = std.mem.splitScalar(u8, input, ' ');
        const year_name = iter.next() orelse return try writer.print("Invalid remember command: \"{s}\".\n", .{input});
        const season_name = iter.next() orelse return try writer.print("Invalid remember command: \"{s}\".\n", .{input});
        const year = std.fmt.parseInt(u16, year_name, 10) catch return try writer.print("Invalid year: \"{s}\".\n", .{year_name});
        if (std.mem.eql(u8, season_name, "spring")) {
            if (memory.springOf(year)) |spring| return rememberMove(game, names, spring, writer, cli_options);
        } else if (std.mem.eql(u8, season_name, "fall")) {
            if (memory.fallOf(year)) |fall| return rememberMove(game, names, fall, writer, cli_options);
        } else if (std.mem.eql(u8, season_name, "winter")) {
            if (memory.winterOf(year)) |winter| return rememberBuild(game, names, winter, writer, cli_options);
        } else {
            return try writer.print("Invalid season: \"{s}\".\n", .{season_name});
        }
        return try writer.print("Invalid year + season: \"{s}\".\n", .{input});
    }
}

fn rememberMove(game: Game, names: Names, snapshot: dip_memory.MoveSnapshot, writer: Writer, cli_options: CliOptions) !void {
    var country_iter = game.countryIterator();
    while (country_iter.next()) |country| {
        try writer.print("\n{s}:\n", .{names.fullNameOf(country)});
        for (snapshot.units, 0..) |unit, idx| {
            if (!std.meta.eql(unit.country, country)) continue;
            const info = UnitInfoForPrint{
                .move = .{
                    .order = .{ .command = unit.command, .status = unit.status },
                    .retreat = if (snapshot.retreatIdxOf(@intCast(idx))) |retreat_idx| blk: {
                        const retreat = snapshot.retreats[retreat_idx];
                        break :blk .{ .to = retreat.to, .status = retreat.status };
                    } else null,
                },
            };
            try printUnit(unit.province, info, names, writer, cli_options);
        }
    }
}

fn rememberBuild(game: Game, names: Names, snapshot: dip_memory.BuildSnapshot, writer: Writer, cli_options: CliOptions) !void {
    var country_iter = game.countryIterator();
    while (country_iter.next()) |country| {
        try writer.print("\n{s}:\n", .{names.fullNameOf(country)});
        for (snapshot.builds) |province| {
            const sc = game.scAt(province).?;
            if (!std.meta.eql(sc.home_owner.?, country)) continue;
            try printUnit(province, .{ .winter = .build }, names, writer, cli_options);
        }
        for (snapshot.units, 0..) |unit, idx| {
            if (!std.meta.eql(unit.country, country)) continue;
            const info: UnitInfoForPrint = if (snapshot.isDisbanded(@intCast(idx))) .{ .winter = .disband } else .{ .winter = .stay };
            try printUnit(unit.province, info, names, writer, cli_options);
        }
    }
}

//    |--------------|
//----|  Sandboxing  |
//    |--------------|

fn takeSandboxOrders(game: *Game, names: Names, reader: Reader, writer: Writer, cli_options: CliOptions) !void {
    if (game.season.isRetreat()) {
        try writer.print("Sandbox does not work in retreat phase.\n", .{});
        return;
    } else if (game.season.isMove()) {
        game.resetCommandAt(null, null) catch unreachable; // Remove all commands.
    } else if (game.season.isBuild()) {
        game.resetBuildAt(null, null) catch unreachable; // Remove all builds.
        game.resetDisbandAt(null, null) catch unreachable; // Remove all disbands.
    } else unreachable;
    var buffer: [256]u8 = undefined;
    while (true) {
        try writer.print("\n>>", .{});
        const raw_input = try reader.readUntilDelimiter(&buffer, '\n');
        const input = std.mem.trimRight(u8, raw_input, "\r");
        var iter = std.mem.splitScalar(u8, input, ' ');
        const command = iter.next() orelse continue;
        if (std.mem.eql(u8, command, ".help")) {
            try sandboxHelp(writer);
        } else if (std.mem.eql(u8, command, ".stop")) {
            return;
        } else if (std.mem.eql(u8, command, ".sc")) {
            try printSC(game.*, names, writer, cli_options);
        } else if (std.mem.eql(u8, command, ".units")) {
            try printAllUnits(game.*, names, null, writer, cli_options);
        } else if (std.mem.eql(u8, command, ".create")) {
            try sandboxCreate(game, names, iter.rest(), writer, cli_options);
        } else if (std.mem.eql(u8, command, ".remove")) {
            try sandboxRemoveUnit(game, names, iter.rest(), writer, cli_options);
        } else if (std.mem.eql(u8, command, ".set")) {
            try sandboxSetSCOwner(game, names, iter.rest(), writer, cli_options);
        } else if (std.mem.eql(u8, command, ".set_neutral")) {
            try sandboxSetSCNeutral(game, names, iter.rest(), writer, cli_options);
        } else if (input.len > 0) {
            try writer.print("Invalid command: \"{s}\"\n", .{command});
        }
    }
}

fn sandboxHelp(writer: Writer) !void {
    try writer.print(".help                             - See this.\n", .{});
    try writer.print(".stop                             - Stop entering sandbox orders and return to game loop.\n", .{});
    try writer.print(".sc                               - Print status of all supply centers.\n", .{});
    try writer.print(".units                            - Print all units.\n", .{});
    try writer.print(".create [A|F] <where> - <country> - Create a new unit.\n", .{});
    try writer.print(".remove <where>                   - Remove unit.\n", .{});
    try writer.print(".set <sc> - <country>             - Changes supply center's owner.\n", .{});
    try writer.print(".set_neutral <sc>                 - Changes supply center to be neutral.\n", .{});
}

fn sandboxCreate(game: *Game, names: Names, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    if (try trySandboxCreateArmy(game, names, input, writer, cli_options)) return;
    if (try trySandboxCreateFleet(game, names, input, writer, cli_options)) return;
    if (try trySandboxCreateProvince(game, names, input, writer, cli_options)) return;
    try writer.print("Could not parse create order \"{s}\".\n", .{input});
}

fn trySandboxCreateArmy(game: *Game, names: Names, input: []const u8, writer: Writer, cli_options: CliOptions) !bool {
    const parse = Parser(&.{ Province, Country }, "A ", &.{" - "}, null).parse;
    const province, const country = parse(names, input) catch return false;
    game.createArmyAt(country, province) catch |err| switch (err) {
        error.WrongAreaType => try writer.print("Cannot create army at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.BusyArea => try writer.print("There is already unit at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.AtCapacity => try writer.print("Cannot create more units than supply centers.\n", .{}),
        error.WrongPhase => unreachable,
    };
    return true;
}

fn trySandboxCreateFleet(game: *Game, names: Names, input: []const u8, writer: Writer, cli_options: CliOptions) !bool {
    const parse = Parser(&.{ Province, Country }, "F ", &.{" - "}, null).parse;
    const province, const country = parse(names, input) catch return false;
    game.createFleetAt(country, province) catch |err| switch (err) {
        error.WrongAreaType => try writer.print("Cannot create fleet at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.CantInferCoast => try writer.print("You need to specify the coast of \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.BusyArea => try writer.print("There is already unit at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.AtCapacity => try writer.print("Cannot create more units than supply centers.\n", .{}),
        error.WrongPhase => unreachable,
    };
    return true;
}

fn trySandboxCreateProvince(game: *Game, names: Names, input: []const u8, writer: Writer, cli_options: CliOptions) !bool {
    const parse = Parser(&.{ Province, Country }, null, &.{" - "}, null).parse;
    const province, const country = parse(names, input) catch return false;
    game.createUnitAt(country, province) catch |err| switch (err) {
        error.BusyArea => try writer.print("There is already unit at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.AtCapacity => try writer.print("Cannot create more units than supply centers.\n", .{}),
        error.WrongPhase => unreachable,
    };
    return true;
}

fn sandboxRemoveUnit(game: *Game, names: Names, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    const province = names.provinceByName(input) catch return try writer.print("Unknown province: \"{s}\".\n", .{input});
    game.removeUnitAt(province) catch |err| switch (err) {
        error.NoUnit => try writer.print("There is no unit at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.WrongPhase => unreachable,
    };
}

fn sandboxSetSCOwner(game: *Game, names: Names, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    const parse = Parser(&.{ Province, Country }, null, &.{" - "}, null).parse;
    const province, const country = parse(names, input) catch return try writer.print("Could not parse set order: \"{s}\".\n", .{input});
    const land = if (province == .land) province.land else return try writer.print("\"{s}\" is not a land province.\n", .{nameOf(names, province, cli_options)});
    game.setSCOwner(country, land) catch |err| switch (err) {
        error.NoSC => try writer.print("There is no supply center at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
    };
}

fn sandboxSetSCNeutral(game: *Game, names: Names, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    const parse = Parser(&.{Province}, null, &.{}, null).parse;
    const province = parse(names, input) catch return try writer.print("Invalid province: \"{s}\".\n", .{input});
    const land = if (province == .land) province.land else return try writer.print("\"{s}\" is not a land province.\n", .{nameOf(names, province, cli_options)});
    game.setSCOwner(null, land) catch |err| switch (err) {
        error.NoSC => try writer.print("There is no supply center at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
    };
}

//    |------------|
//----|  Commands  |
//    |------------|

fn takeMoveOrders(game: *Game, names: Names, country_mb: ?Country, reader: Reader, writer: Writer, cli_options: CliOptions) !void {
    var buffer: [256]u8 = undefined;
    const country_name = if (country_mb) |country| nameOf(names, country, cli_options) else "";
    while (true) {
        try writer.print("\n{s}>>", .{country_name});
        const raw_input = try reader.readUntilDelimiter(&buffer, '\n');
        const input = std.mem.trimRight(u8, raw_input, "\r");
        var iter = std.mem.splitScalar(u8, input, ' ');
        const word = iter.next() orelse continue;
        if (std.mem.eql(u8, word, ".help")) {
            try orderMoveHelp(writer);
        } else if (std.mem.eql(u8, word, ".help_command")) {
            try orderMoveHelpCommand(writer);
        } else if (std.mem.eql(u8, word, ".help_legal")) {
            try orderMoveHelpLegal(writer);
        } else if (std.mem.eql(u8, word, ".units")) {
            try printAllUnits(game.*, names, country_mb, writer, cli_options);
        } else if (std.mem.eql(u8, word, ".reset")) {
            try resetCommand(game, names, country_mb, iter.rest(), writer, cli_options);
        } else if (std.mem.eql(u8, word, ".legal")) {
            try printLegalCommands(game.*, names, iter.rest(), writer, cli_options);
        } else if (std.mem.eql(u8, word, ".stop")) {
            return;
        } else if (input.len > 0) {
            try issueCommand(game, names, country_mb, input, writer, cli_options);
        }
    }
}

fn orderMoveHelp(writer: Writer) !void {
    try writer.print(".help                     - See this.\n", .{});
    try writer.print(".help_command             - See formating for orders.\n", .{});
    try writer.print(".help_legal               - See formating for getting legal orders.\n", .{});
    try writer.print(".units                    - Print all units with their orders.\n", .{});
    try writer.print(".reset [who]              - Resets all or selected order.\n", .{});
    try writer.print(".stop                     - Stop entering orders and return to game loop.\n", .{});
    try writer.print(".legal <order_start>      - Print legal continuations. Type \".help_legal\" for formatting.\n", .{});
    try writer.print("<order>                   - Issue a command. Type \".help_command\" for formatting.\n", .{});
}

fn orderMoveHelpCommand(writer: Writer) !void {
    try writer.print("<who> h                   - Hold.\n", .{});
    try writer.print("<who> - <to>              - Move.\n", .{});
    try writer.print("<who> c- <to>             - Move via convoy.\n", .{});
    try writer.print("<who> s <at>              - Support hold.\n", .{});
    try writer.print("<who> s <from> - <to>     - Support move.\n", .{});
    try writer.print("<who> c <from> - <to>     - Convoy.\n", .{});
}

fn orderMoveHelpLegal(writer: Writer) !void {
    try writer.print(".legal <who> -            - Print legal moves.\n", .{});
    try writer.print(".legal <who> c-           - Print legal moves via convoy.\n", .{});
    try writer.print(".legal <who> s            - Print legal supports.\n", .{});
    try writer.print(".legal <who> s <from>     - Print legal support of given unit.\n", .{});
    try writer.print(".legal <who> c            - Print legal convoys.\n", .{});
    try writer.print(".legal <who> c <from>     - Print legal convoys of given unit.\n", .{});
}

fn resetCommand(game: *Game, names: Names, country_mb: ?Country, province_name: []const u8, writer: Writer, cli_options: CliOptions) !void {
    const province_mb: ?Province = if (province_name.len == 0) null else names.provinceByName(province_name) catch {
        try writer.print("Unknown province: \"{s}\"\n", .{province_name});
        return;
    };
    game.resetCommandAt(country_mb, province_mb) catch |err| switch (err) {
        error.NoUnit => try writer.print("No unit at \"{s}\".\n", .{nameOf(names, province_mb.?, cli_options)}),
        error.WrongCountry => try writer.print("Unit at \"{s}\" is of another country.\n", .{nameOf(names, province_mb.?, cli_options)}),
        error.WrongPhase => unreachable,
    };
}

const ParseLegalCommandResult = struct {
    province: Province,
    iter: union(enum) {
        move: dip.Game.LegalMoveIterator,
        convoy_move: dip.Game.LegalConvoyMoveIterator,
        support_all: dip.Game.LegalSupportAllIterator,
        support_from: dip.Game.LegalSupportFromIterator,
        transport_all: dip.Game.LegalTransportAllIterator,
        transport_from: dip.Game.LegalTransportFromIterator,

        fn next(self: *@This()) ?dip.Command {
            switch (self.*) {
                inline else => |*iter| return iter.next(),
            }
        }
    },
};

fn printLegalCommands(game: Game, names: Names, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    var result: ParseLegalCommandResult = undefined;
    if (parseLegalMove(game, names, input)) |r| {
        result = r;
    } else if (parseLegalConvoyMove(game, names, input)) |r| {
        result = r;
    } else if (parseLegalSupportAll(game, names, input)) |r| {
        result = r;
    } else if (parseLegalSupportFrom(game, names, input)) |r| {
        result = r;
    } else if (parseLegalTransportAll(game, names, input)) |r| {
        result = r;
    } else if (parseLegalTransportFrom(game, names, input)) |r| {
        result = r;
    } else return try writer.print("Could not parse \"{s}\". Type \".help_legal\" for formatting. Check that all provinces are spelled correctly and have units in them\n", .{input});

    const unit_idx = game.unitIdxAt(result.province) orelse return;
    const unit = game.units.items[unit_idx];
    var iter = result.iter;
    try writer.print("\n", .{});
    while (iter.next()) |command| {
        try writer.print("{s: <10}{s}", .{ "", nameOf(names, unit.province, cli_options) });
        try printCommand(command, names, writer, cli_options);
        try writer.print("\n", .{});
    }
}

fn parseLegalMove(game: Game, names: Names, input: []const u8) ?ParseLegalCommandResult {
    const parse = Parser(&.{Province}, null, &.{}, " -").parse;
    const province = parse(names, input) catch return null;
    const unit_idx = game.unitIdxAt(province) orelse return null;
    const iter = game.legalMoveIterator(unit_idx) catch unreachable;
    return .{ .province = province, .iter = .{ .move = iter } };
}

fn parseLegalConvoyMove(game: Game, names: Names, input: []const u8) ?ParseLegalCommandResult {
    const parse = Parser(&.{Province}, null, &.{}, " c-").parse;
    const province = parse(names, input) catch return null;
    const unit_idx = game.unitIdxAt(province) orelse return null;
    const iter = game.legalConvoyMoveIterator(unit_idx) catch unreachable;
    return .{ .province = province, .iter = .{ .convoy_move = iter } };
}

fn parseLegalSupportAll(game: Game, names: Names, input: []const u8) ?ParseLegalCommandResult {
    const parse = Parser(&.{Province}, null, &.{}, " s").parse;
    const province = parse(names, input) catch return null;
    const unit_idx = game.unitIdxAt(province) orelse return null;
    const iter = game.legalSupportAllIterator(unit_idx) catch unreachable;
    return .{ .province = province, .iter = .{ .support_all = iter } };
}

fn parseLegalSupportFrom(game: Game, names: Names, input: []const u8) ?ParseLegalCommandResult {
    const parse = Parser(&.{ Province, Province }, null, &.{" s "}, null).parse;
    const province, const other = parse(names, input) catch return null;
    const unit_idx = game.unitIdxAt(province) orelse return null;
    const other_idx = game.unitIdxAt(other) orelse return null;
    const iter = game.legalSupportFromIterator(unit_idx, other_idx) catch unreachable;
    return .{ .province = province, .iter = .{ .support_from = iter } };
}

fn parseLegalTransportAll(game: Game, names: Names, input: []const u8) ?ParseLegalCommandResult {
    const parse = Parser(&.{Province}, null, &.{}, " c").parse;
    const province = parse(names, input) catch return null;
    const unit_idx = game.unitIdxAt(province) orelse return null;
    const iter = game.legalTransportAllIterator(unit_idx) catch unreachable;
    return .{ .province = province, .iter = .{ .transport_all = iter } };
}

fn parseLegalTransportFrom(game: Game, names: Names, input: []const u8) ?ParseLegalCommandResult {
    const parse = Parser(&.{ Province, Province }, null, &.{" c "}, null).parse;
    const province, const other = parse(names, input) catch return null;
    const unit_idx = game.unitIdxAt(province) orelse return null;
    const other_idx = game.unitIdxAt(other) orelse return null;
    const iter = game.legalTransportFromIterator(unit_idx, other_idx) catch unreachable;
    return .{ .province = province, .iter = .{ .transport_from = iter } };
}

const ParseMoveResult = struct { province: Province, command: dip.Command };

fn issueCommand(game: *Game, names: Names, country_mb: ?Country, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    var result: ParseMoveResult = undefined;
    if (parseHold(names, input)) |r| {
        result = r;
    } else if (parseMove(names, input)) |r| {
        result = r;
    } else if (parseConvoyMove(names, input)) |r| {
        result = r;
    } else if (parseSupportHold(names, input)) |r| {
        result = r;
    } else if (parseSupportMove(names, input)) |r| {
        result = r;
    } else if (parseConvoyTransport(names, input)) |r| {
        result = r;
    } else return try writer.print("Could not parse order: \"{s}\". Type \".help_command\" for formatting.\n", .{input});

    game.issueCommandAt(country_mb, result.province, result.command) catch |err| switch (err) {
        error.NoUnit => try writer.print("No unit at \"{s}\".\n", .{nameOf(names, result.province, cli_options)}),
        error.WrongCountry => try writer.print("Unit at \"{s}\" is of another country.\n", .{nameOf(names, result.province, cli_options)}),
        error.DuplicateOrder => try writer.print("Unit at \"{s}\" already has an order.\n", .{nameOf(names, result.province, cli_options)}),
        error.WrongAreaType => try writer.print("Movement between land and non-land provinces is impossible.\n", .{}),
        error.CantInferCoast => try writer.print("More than one coast is available, specify one.\n", .{}),
        error.NoPath => try writer.print("There is no path between \"{s}\" and \"{s}\".\n", .{ nameOf(names, result.province, cli_options), nameOf(names, result.command.to().?, cli_options) }),
        error.NoOtherUnit => try writer.print("There is no unit at \"{s}\".\n", .{nameOf(names, result.command.other().?, cli_options)}),
        error.TransportNoPath => try writer.print("There is no convoy path through \"{s}\" between \"{s}\" and \"{s}\".\n", .{ nameOf(names, result.province, cli_options), nameOf(names, result.command.convoy_transport.from, cli_options), nameOf(names, result.command.convoy_transport.to, cli_options) }),
        error.SupportNoPath => try writer.print("There is no path between \"{s}\" and \"{s}\".\n", .{ nameOf(names, result.command.support_move.from, cli_options), nameOf(names, result.command.support_move.to, cli_options) }),
        error.CantSupport => try writer.print("Unit at \"{s}\" can't support to \"{s}\".\n", .{ nameOf(names, result.province, cli_options), nameOf(names, result.command.otherTo().?, cli_options) }),
        error.WrongType => switch (result.command) {
            .convoy_move => try writer.print("Only armies can move via convoy.\n", .{}),
            .convoy_transport => try writer.print("Convoys must be ordered to fleets in water for movement of armies.\n", .{}),
            else => unreachable,
        },
        error.WrongPhase => unreachable,
    };
    return;
}

fn parseHold(names: Names, input: []const u8) ?ParseMoveResult {
    const parse = Parser(&.{Province}, null, &.{}, " h").parse;
    const province = parse(names, input) catch return null;
    return .{ .province = province, .command = .{ .hold = .{} } };
}

fn parseMove(names: Names, input: []const u8) ?ParseMoveResult {
    const parse = Parser(&.{ Province, Province }, null, &.{" - "}, null).parse;
    const province, const to = parse(names, input) catch return null;
    return .{ .province = province, .command = .{ .move = .{ .to = to } } };
}

fn parseConvoyMove(names: Names, input: []const u8) ?ParseMoveResult {
    const parse = Parser(&.{ Province, Province }, null, &.{" c- "}, null).parse;
    const province, const to = parse(names, input) catch return null;
    return .{ .province = province, .command = .{ .convoy_move = .{ .to = to } } };
}

fn parseSupportHold(names: Names, input: []const u8) ?ParseMoveResult {
    const parse = Parser(&.{ Province, Province }, null, &.{" s "}, null).parse;
    const province, const at = parse(names, input) catch return null;
    return .{ .province = province, .command = .{ .support_hold = .{ .at = at } } };
}

fn parseSupportMove(names: Names, input: []const u8) ?ParseMoveResult {
    const parse = Parser(&.{ Province, Province, Province }, null, &.{ " s ", " - " }, null).parse;
    const province, const from, const to = parse(names, input) catch return null;
    return .{ .province = province, .command = .{ .support_move = .{ .from = from, .to = to } } };
}

fn parseConvoyTransport(names: Names, input: []const u8) ?ParseMoveResult {
    const parse = Parser(&.{ Province, Province, Province }, null, &.{ " c ", " - " }, null).parse;
    const province, const from, const to = parse(names, input) catch return null;
    return .{ .province = province, .command = .{ .convoy_transport = .{ .from = from, .to = to } } };
}

//    |------------|
//----|  Retreats  |
//    |------------|

fn takeRetreatOrders(game: *Game, names: Names, country_mb: ?Country, reader: Reader, writer: Writer, cli_options: CliOptions) !void {
    var buffer: [256]u8 = undefined;
    const country_name = if (country_mb) |country| nameOf(names, country, cli_options) else "";
    while (true) {
        try writer.print("\n{s}>>", .{country_name});
        const raw_input = try reader.readUntilDelimiter(&buffer, '\n');
        const input = std.mem.trimRight(u8, raw_input, "\r");
        var iter = std.mem.splitScalar(u8, input, ' ');
        const command = iter.next() orelse continue;
        if (std.mem.eql(u8, command, ".help")) {
            try orderRetreatHelp(writer);
        } else if (std.mem.eql(u8, command, ".stop")) {
            return;
        } else if (std.mem.eql(u8, command, ".units")) {
            try printAllUnits(game.*, names, country_mb, writer, cli_options);
        } else if (std.mem.eql(u8, command, ".reset")) {
            try resetRetreat(game, names, country_mb, iter.rest(), writer, cli_options);
        } else if (std.mem.eql(u8, command, ".legal")) {
            try printLegalRetreats(game.*, names, iter.rest(), writer, cli_options);
        } else if (input.len > 0) {
            try issueRetreat(game, names, country_mb, input, writer, cli_options);
        }
    }
}

fn orderRetreatHelp(writer: Writer) !void {
    try writer.print(".help                     - See this.\n", .{});
    try writer.print(".stop                     - Stop entering orders and return to game loop.\n", .{});
    try writer.print(".units                    - Print all units with their orders and need for retreats.\n", .{});
    try writer.print(".reset [who]              - Resets all or selected order.\n", .{});
    try writer.print(".legal [who]              - Prints all available retreats for a given unit.\n", .{});
    try writer.print("<who> d                   - Disband.\n", .{});
    try writer.print("<who> - <to>              - Retreat.\n", .{});
}

fn resetRetreat(game: *Game, names: Names, country_mb: ?Country, province_name: []const u8, writer: Writer, cli_options: CliOptions) !void {
    const province = if (province_name.len == 0) null else names.provinceByName(province_name) catch {
        try writer.print("Unknown province: \"{s}\"\n", .{province_name});
        return;
    };
    game.resetRetreatAt(country_mb, province) catch |err| switch (err) {
        error.NoUnit => try writer.print("No unit at \"{s}\".\n", .{nameOf(names, province.?, cli_options)}),
        error.WrongCountry => try writer.print("Unit at \"{s}\" is of another country.\n", .{nameOf(names, province.?, cli_options)}),
        else => unreachable,
    };
}

fn printLegalRetreats(game: Game, names: Names, province_name: []const u8, writer: Writer, cli_options: CliOptions) !void {
    const province = names.provinceByName(province_name) catch return try writer.print("Unknown province: \"{s}\"\n", .{province_name});
    const unit_idx = game.unitIdxAt(province) orelse return try writer.print("No unit at \"{s}\".\n", .{nameOf(names, province, cli_options)});
    const unit = game.units.items[unit_idx];
    if (!(game.shouldRetreat(unit_idx) catch unreachable)) return try writer.print("Unit at \"{s}\" doesn't need to retreat.\n", .{nameOf(names, province, cli_options)});
    try writer.print("\n", .{});
    try writer.print("{s: <10}{s} d\n", .{ "", nameOf(names, unit.province, cli_options) });
    var retreat_iter = game.legalRetreatIterator(unit_idx) catch unreachable;
    while (retreat_iter.next()) |to| {
        try writer.print("{s: <10}{s} - {s}\n", .{ "", nameOf(names, unit.province, cli_options), nameOf(names, to, cli_options) });
    }
}

const ParseRetreatResult = struct { province: Province, to: ?Province };

fn issueRetreat(game: *Game, names: Names, country_mb: ?Country, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    var result: ParseRetreatResult = undefined;
    if (parseRetreatDisband(names, input)) |r| {
        result = r;
    } else if (parseRetreat(names, input)) |r| {
        result = r;
    } else try writer.print("Could not parse retreat order: \"{s}\".\n", .{input});

    game.issueRetreatAt(country_mb, result.province, result.to) catch |err| switch (err) {
        error.NoUnit => try writer.print("No unit at \"{s}\".\n", .{nameOf(names, result.province, cli_options)}),
        error.WrongCountry => try writer.print("Unit at \"{s}\" is of another country.\n", .{nameOf(names, result.province, cli_options)}),
        error.DuplicateOrder => try writer.print("Unit at \"{s}\" already has an order.\n", .{nameOf(names, result.province, cli_options)}),
        error.BusyArea => try writer.print("\"{s}\" is not available for retreat.\n", .{nameOf(names, result.to.?, cli_options)}),
        error.NotDislodged => try writer.print("Unit at \"{s}\" doesn't need to retreat.\n", .{nameOf(names, result.province, cli_options)}),
        error.HeadToHead => try writer.print("Unit at \"{s}\" cannot retreat to area of its attacker.\n", .{nameOf(names, result.province, cli_options)}),
        error.NoBorder => try writer.print("\"{s}\" doesn't border \"{s}\".\n", .{ nameOf(names, result.province, cli_options), nameOf(names, result.to.?, cli_options) }),
        error.WrongAreaType => try writer.print("Movement between land and non-land provinces is impossible.\n", .{}),
        error.CantInferCoast => try writer.print("More than one coast is available, specify one.\n", .{}),
        error.WrongPhase => unreachable,
    };
    return;
}

fn parseRetreatDisband(names: Names, input: []const u8) ?ParseRetreatResult {
    const parse = Parser(&.{Province}, null, &.{}, " d").parse;
    const province = parse(names, input) catch return null;
    return .{ .province = province, .to = null };
}

fn parseRetreat(names: Names, input: []const u8) ?ParseRetreatResult {
    const parse = Parser(&.{ Province, Province }, null, &.{" - "}, null).parse;
    const province, const to = parse(names, input) catch return null;
    return .{ .province = province, .to = to };
}

//    |----------|
//----|  Builds  |
//    |----------|

fn takeBuildOrders(game: *Game, names: Names, country_mb: ?Country, reader: Reader, writer: Writer, cli_options: CliOptions) !void {
    var buffer: [256]u8 = undefined;
    const country_name = if (country_mb) |country| nameOf(names, country, cli_options) else "";
    while (true) {
        try writer.print("\n{s}>>", .{country_name});
        const raw_input = try reader.readUntilDelimiter(&buffer, '\n');
        const input = std.mem.trimRight(u8, raw_input, "\r");
        var iter = std.mem.splitScalar(u8, input, ' ');
        const word = iter.next() orelse continue;
        if (std.mem.eql(u8, word, ".help")) {
            try orderBuildHelp(writer);
        } else if (std.mem.eql(u8, word, ".stop")) {
            return;
        } else if (std.mem.eql(u8, word, ".units")) {
            try printAllUnits(game.*, names, country_mb, writer, cli_options);
        } else if (std.mem.eql(u8, word, ".reset")) {
            try resetAdjustment(game, names, country_mb, iter.rest(), writer, cli_options);
        } else if (std.mem.eql(u8, word, ".legal")) {
            try printLegalAdjustments(game, names, country_mb, writer, cli_options);
        } else if (input.len > 0) {
            try issueBuild(game, names, country_mb, input, writer, cli_options);
        }
    }
}

fn orderBuildHelp(writer: Writer) !void {
    try writer.print(".help                     - See this.\n", .{});
    try writer.print(".stop                     - Stop entering orders and return to game loop.\n", .{});
    try writer.print(".units                    - Print all units.\n", .{});
    try writer.print(".reset [where]            - Resets all or selected order.\n", .{});
    try writer.print(".legal                    - Prints all available builds/disbands.\n", .{});
    try writer.print("b [A|F] <where>           - Build.\n", .{});
    try writer.print("d <where>                 - Disband.\n", .{});
}

fn resetAdjustment(game: *Game, names: Names, country_mb: ?Country, province_name: []const u8, writer: Writer, cli_options: CliOptions) !void {
    const province: ?Province = if (province_name.len == 0) null else names.provinceByName(province_name) catch {
        return try writer.print("Unknown province: \"{s}\"\n", .{province_name});
    };
    if (game.resetBuildAt(country_mb, province)) |_| return else |err| switch (err) {
        error.NoOrder => {},
        error.WrongCountry => return try writer.print("Build order at \"{s}\" is of another country.\n", .{nameOf(names, province.?, cli_options)}),
        error.WrongPhase => unreachable,
    }
    if (game.resetDisbandAt(country_mb, province)) |_| return else |err| switch (err) {
        error.NoOrder => {},
        error.WrongCountry => return try writer.print("Disband order for \"{s}\" is of another country.\n", .{nameOf(names, province.?, cli_options)}),
        error.WrongPhase => unreachable,
    }
    try writer.print("There is no order for \"{s}\".\n", .{nameOf(names, province.?, cli_options)});
}

fn printLegalAdjustments(game: *Game, names: Names, country_mb: ?Country, writer: Writer, cli_options: CliOptions) !void {
    if (country_mb) |country| {
        try writer.print("\n{s}:\n", .{names.fullNameOf(country)});
        if (game.buildsLeft(country) catch unreachable > 0) {
            try writer.print("{d} builds left.\n", .{game.buildsLeft(country) catch unreachable});
            for (game.supply_centers) |sc| {
                if (game.isLegalBuild(country, sc.land.province()) catch unreachable) {
                    try writer.print("{s: <10}{s}", .{ "", nameOf(names, sc.land, cli_options) });
                    if (game.buildIdxAt(sc.land.province())) |build_idx| {
                        if (game.builds.items[build_idx] == .land) try writer.print(" b A\n", .{}) else try writer.print(" b F\n", .{});
                    } else try writer.print("\n", .{});
                }
            }
        } else if (game.disbandsLeft(country) catch unreachable > 0) {
            try writer.print("{d} disbands left.\n", .{game.disbandsLeft(country) catch unreachable});
            for (game.units.items, 0..) |unit, idx| {
                if (game.isLegalDisband(country, @intCast(idx)) catch unreachable) {
                    try writer.print("{s: <10}{s}", .{ "", nameOf(names, unit.province, cli_options) });
                    if (game.disbandIdxOf(@intCast(idx)) == null) try writer.print("\n", .{}) else try writer.print(" d\n", .{});
                }
            }
        } else {
            try writer.print("No orders available.\n", .{});
        }
    } else {
        var country_iter = game.countryIterator();
        while (country_iter.next()) |country| {
            try printLegalAdjustments(game, names, country, writer, cli_options);
        }
    }
}

fn issueBuild(game: *Game, names: Names, country_mb: ?Country, input: []const u8, writer: Writer, cli_options: CliOptions) !void {
    if (try issueDisband(game, names, country_mb, input, writer, cli_options)) return;
    if (try issueBuildArmy(game, names, country_mb, input, writer, cli_options)) return;
    if (try issueBuildFleet(game, names, country_mb, input, writer, cli_options)) return;
    if (try issueBuildProvince(game, names, country_mb, input, writer, cli_options)) return;
    try writer.print("Could not parse build order: \"{s}\".\n", .{input});
}

fn issueDisband(game: *Game, names: Names, country_mb: ?Country, input: []const u8, writer: Writer, cli_options: CliOptions) !bool {
    const parse = Parser(&.{Province}, "d ", &.{}, null).parse;
    const province = parse(names, input) catch return false;
    game.issueDisbandAt(country_mb, province) catch |err| switch (err) {
        error.NoUnit => try writer.print("No unit at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.WrongCountry => try writer.print("Unit at \"{s}\" is of another country.\n", .{nameOf(names, province, cli_options)}),
        error.DuplicateOrder => try writer.print("Unit at \"{s}\" is already being disbanded.\n", .{nameOf(names, province, cli_options)}),
        error.DontNeed => try writer.print("You don't need to disband this phase.\n", .{}),
        error.ExtraBuild => try writer.print("You can't order more disbands.\n", .{}),
        error.WrongPhase => unreachable,
    };
    return true;
}

fn issueBuildArmy(game: *Game, names: Names, country_mb: ?Country, input: []const u8, writer: Writer, cli_options: CliOptions) !bool {
    const parse = Parser(&.{Province}, "b A ", &.{}, null).parse;
    const province = parse(names, input) catch return false;
    game.issueBuildArmy(country_mb, province) catch |err| switch (err) {
        error.DuplicateOrder => try writer.print("There is already an order to build at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.NoSC => try writer.print("\"{s}\" is not a supply center.\n", .{nameOf(names, province, cli_options)}),
        error.NotHome => try writer.print("\"{s}\" is not a home supply center.\n", .{nameOf(names, province, cli_options)}),
        error.NotOwnedHome => try writer.print("\"{s}\" is not owned by its home country.\n", .{nameOf(names, province, cli_options)}),
        error.WrongAreaType => try writer.print("Cannot build army at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.BusyArea => try writer.print("There is already unit at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.DontNeed => try writer.print("You don't need to build this phase.\n", .{}),
        error.ExtraBuild => try writer.print("You can't order more builds.\n", .{}),
        error.WrongPhase => unreachable,
    };
    return true;
}

fn issueBuildFleet(game: *Game, names: Names, country_mb: ?Country, input: []const u8, writer: Writer, cli_options: CliOptions) !bool {
    const parse = Parser(&.{Province}, "b F ", &.{}, null).parse;
    const province = parse(names, input) catch return false;
    game.issueBuildFleet(country_mb, province) catch |err| switch (err) {
        error.DuplicateOrder => try writer.print("There is already an order to build at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.NoSC => try writer.print("\"{s}\" is not a supply center.\n", .{nameOf(names, province, cli_options)}),
        error.NotHome => try writer.print("\"{s}\" is not a home supply center.\n", .{nameOf(names, province, cli_options)}),
        error.NotOwnedHome => try writer.print("\"{s}\" is not owned by its home country.\n", .{nameOf(names, province, cli_options)}),
        error.WrongAreaType => try writer.print("Cannot build fleet at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.CantInferCoast => try writer.print("You need to specify the coast of \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.BusyArea => try writer.print("There is already unit at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.DontNeed => try writer.print("You don't need to build this phase.\n", .{}),
        error.ExtraBuild => try writer.print("You can't order more builds.\n", .{}),
        error.WrongPhase => unreachable,
    };
    return true;
}

fn issueBuildProvince(game: *Game, names: Names, country_mb: ?Country, input: []const u8, writer: Writer, cli_options: CliOptions) !bool {
    const parse = Parser(&.{Province}, "b ", &.{}, null).parse;
    const province = parse(names, input) catch return false;
    game.issueBuild(country_mb, province) catch |err| switch (err) {
        error.DuplicateOrder => try writer.print("There is already an order to build at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.NoSC => try writer.print("\"{s}\" is not a supply center.\n", .{nameOf(names, province, cli_options)}),
        error.NotHome => try writer.print("\"{s}\" is not a home supply center.\n", .{nameOf(names, province, cli_options)}),
        error.NotOwnedHome => try writer.print("\"{s}\" is not owned by its home country.\n", .{nameOf(names, province, cli_options)}),
        error.BusyArea => try writer.print("There is already unit at \"{s}\".\n", .{nameOf(names, province, cli_options)}),
        error.DontNeed => try writer.print("You don't need to build this phase.\n", .{}),
        error.ExtraBuild => try writer.print("You can't order more builds.\n", .{}),
        error.WrongPhase => unreachable,
    };
    return true;
}
