const std = @import("std");
const dip = @import("dip.zig");

pub const Name = []const u8;
pub const Pair = struct { Name, Name };

/// Used for defining areas.
/// `coasts==null` means water tile. `coasts==[]` means landlocked land tile.
pub const Area = struct { name: Name, coasts: ?[]const Name };

/// Used for alphabetically sorting areas for civil disorder.
fn areaLessThanFn(_: void, a: Area, b: Area) bool {
    return std.ascii.lessThanIgnoreCase(b.name, a.name);
}

/// Used for defining countries and starting positions.
/// Units are placed at their areas.
/// Supply centers are placed at corresponding land tiles and made home centers.
pub const CountryStart = struct { name: Name, starting_units: []const Name };

pub const UnknownName = error{UnknownName};
pub const GameError = error{ SCNotOnLand, IllegalBorder, UnitNotOnSC, UnitsShareSC };
pub const NamesInitError = error{RepeatName} || std.mem.Allocator.Error;
pub const GameInitError = GameError || UnknownName || std.mem.Allocator.Error;
pub const InitError = NamesInitError || GameInitError;

pub const GameAndNames = struct { dip.Game, NamesData };

/// Allows to interface with game using strings. Does not care about case.
/// Does not own the memory.
pub const NamesData = struct {
    // For obj<->name lookup the obj.id is used as index into arrays below.
    // Might try case-insensitive hasmap later.
    countries: std.ArrayListUnmanaged(Name),
    lands: std.ArrayListUnmanaged(Name),
    waters: std.ArrayListUnmanaged(Name),
    coasts: std.ArrayListUnmanaged(Name),

    /// First name is shortcut, second name is the substitute.
    shortcuts: []const Pair,

    pub fn init(allocator: std.mem.Allocator, areas: []const Area, countries_starts: []const CountryStart, shortcuts: []const Pair) NamesInitError!NamesData {
        const countries = std.ArrayListUnmanaged(Name){};
        const lands = std.ArrayListUnmanaged(Name){};
        const waters = std.ArrayListUnmanaged(Name){};
        const coasts = std.ArrayListUnmanaged(Name){};
        var names = NamesData{
            .countries = countries,
            .lands = lands,
            .waters = waters,
            .coasts = coasts,
            .shortcuts = shortcuts,
        };
        for (countries_starts) |country_start| {
            try names.addName(allocator, dip.Country, country_start.name);
        }
        for (areas) |area| {
            if (area.coasts) |area_coasts| {
                try names.addName(allocator, dip.Land, area.name);
                for (area_coasts) |coast| {
                    try names.addName(allocator, dip.Coast, coast);
                }
            } else {
                try names.addName(allocator, dip.Water, area.name);
            }
        }
        return names;
    }

    fn addName(self: *NamesData, allocator: std.mem.Allocator, comptime T: type, name: Name) NamesInitError!void {
        if (self.landByName(name)) |_| return error.RepeatName else |_| {}
        if (self.waterByName(name)) |_| return error.RepeatName else |_| {}
        if (self.coastByName(name)) |_| return error.RepeatName else |_| {}
        if (self.countryByName(name)) |_| return error.RepeatName else |_| {}
        switch (T) {
            dip.Coast => try self.coasts.append(allocator, name),
            dip.Land => try self.lands.append(allocator, name),
            dip.Water => try self.waters.append(allocator, name),
            dip.Country => try self.countries.append(allocator, name),
            else => unreachable,
        }
    }

    pub fn deinit(self: *NamesData, allocator: std.mem.Allocator) void {
        self.countries.deinit(allocator);
        self.lands.deinit(allocator);
        self.waters.deinit(allocator);
        self.coasts.deinit(allocator);
        self.* = undefined;
    }

    /// Returns the name of the object.
    pub fn fullNameOf(self: NamesData, obj: anytype) Name {
        switch (@TypeOf(obj)) {
            dip.Country => return self.countries.items[obj.id],
            dip.Coast => return self.coasts.items[obj.id],
            dip.Land => return self.lands.items[obj.id],
            dip.Water => return self.waters.items[obj.id],
            dip.Province => {
                switch (obj) {
                    .coast => |coast| return self.coasts.items[coast.id],
                    .land => |land| return self.lands.items[land.id],
                    .water => |water| return self.waters.items[water.id],
                }
            },
            else => unreachable,
        }
    }

    /// Gets the name, and if there exists a short name, returns it instead.
    pub fn shortNameOf(self: NamesData, obj: anytype) Name {
        const name = self.fullNameOf(obj);
        return self.shortName(name) catch name;
    }

    /// Searches for the name in shortcuts and returns corresponding full name.
    pub fn fullName(self: NamesData, name: Name) UnknownName!Name {
        for (self.shortcuts) |pair| {
            if (std.ascii.eqlIgnoreCase(pair[0], name)) return pair[1];
        }
        return error.UnknownName;
    }

    /// Searches for the name in shortcuts and returns corresponding short name.
    pub fn shortName(self: NamesData, name: Name) UnknownName!Name {
        for (self.shortcuts) |pair| {
            if (std.ascii.eqlIgnoreCase(pair[1], name)) return pair[0];
        }
        return error.UnknownName;
    }

    pub fn countryByName(self: NamesData, name: Name) UnknownName!dip.Country {
        const full_name = self.fullName(name) catch name;
        for (self.countries.items, 0..) |country, i| {
            if (std.ascii.eqlIgnoreCase(country, full_name)) return .{ .id = @intCast(i) };
        }
        return error.UnknownName;
    }

    pub fn landByName(self: NamesData, name: Name) UnknownName!dip.Land {
        const full_name = self.fullName(name) catch name;
        for (self.lands.items, 0..) |land, i| {
            if (std.ascii.eqlIgnoreCase(land, full_name)) return .{ .id = @intCast(i) };
        }
        return error.UnknownName;
    }

    pub fn coastByName(self: NamesData, name: Name) UnknownName!dip.Coast {
        const full_name = self.fullName(name) catch name;
        for (self.coasts.items, 0..) |coast, i| {
            if (std.ascii.eqlIgnoreCase(coast, full_name)) return .{ .id = @intCast(i) };
        }
        return error.UnknownName;
    }

    pub fn waterByName(self: NamesData, name: Name) UnknownName!dip.Water {
        const full_name = self.fullName(name) catch name;
        for (self.waters.items, 0..) |water, i| {
            if (std.ascii.eqlIgnoreCase(water, full_name)) return .{ .id = @intCast(i) };
        }
        return error.UnknownName;
    }

    pub fn provinceByName(self: NamesData, name: Name) UnknownName!dip.Province {
        if (self.landByName(name)) |v| return .{ .land = v } else |_| {}
        if (self.waterByName(name)) |v| return .{ .water = v } else |_| {}
        if (self.coastByName(name)) |v| return .{ .coast = v } else |_| {}
        return error.UnknownName;
    }

    //  |-------------------|
    //--|  Creating a Game  |
    //  |-------------------|

    pub fn initGameAndNames(
        allocator: std.mem.Allocator,
        areas: []const Area,
        pairs: []const Pair,
        supply_centers: []const Name,
        countries_starts: []const CountryStart,
        shortcuts: []const Pair,
    ) InitError!GameAndNames {
        const names = try NamesData.init(allocator, areas, countries_starts, shortcuts);
        const game = try names.initGame(allocator, areas, pairs, supply_centers, countries_starts);
        return .{ game, names };
    }

    pub fn initGame(self: NamesData, allocator: std.mem.Allocator, areas: []const Area, pairs: []const Pair, supply_centers: []const Name, countries_starts: []const CountryStart) GameInitError!dip.Game {
        var game = try dip.Game.initEmpty(
            allocator,
            @intCast(self.countries.items.len),
            @intCast(self.lands.items.len),
            @intCast(self.waters.items.len),
            @intCast(self.coasts.items.len),
            @intCast(supply_centers.len),
            @intCast(pairs.len),
        );

        const areas_sorted = try allocator.dupe(Area, areas);
        defer allocator.free(areas_sorted);
        std.mem.sort(Area, areas_sorted, {}, areaLessThanFn);

        try self.fillMap(&game.map, areas_sorted, pairs);
        try self.fillSC(&game, supply_centers);
        try self.fillStartingPosition(&game, countries_starts);
        return game;
    }

    fn fillSC(self: NamesData, game: *dip.Game, supply_centers: []const Name) GameInitError!void {
        for (supply_centers, 0..) |sc_name, i| {
            const province = try self.provinceByName(sc_name);
            if (province != .land) return error.SCNotOnLand;
            game.supply_centers[i] = .{ .land = province.land, .owner = null, .home_owner = null };
        }
    }

    fn fillStartingPosition(self: NamesData, game: *dip.Game, countries_starts: []const CountryStart) GameInitError!void {
        for (countries_starts) |country_start| {
            const country = try self.countryByName(country_start.name);
            for (country_start.starting_units) |province_name| {
                const unit_province = try self.provinceByName(province_name);
                const sc_province = game.map.areaOf(unit_province);
                const sc_land = if (sc_province == .land) sc_province.land else return error.UnitNotOnSC;
                for (game.supply_centers) |*sc| if (std.meta.eql(sc.land, sc_land)) {
                    if (sc.owner != null) return error.UnitsShareSC;
                    sc.owner = country;
                    sc.home_owner = country;
                    game.units.appendAssumeCapacity(.{ .province = unit_province, .country = country });
                    break;
                };
            }
        }
    }

    fn fillMap(self: NamesData, map: *dip.Map, areas_sorted: []const Area, pairs: []const Pair) GameInitError!void {
        try self.fillCoastOwners(map, areas_sorted);
        try self.fillEdges(map, pairs);
        try self.fillSortedAreas(map, areas_sorted);
    }

    fn fillCoastOwners(self: NamesData, map: *dip.Map, areas_sorted: []const Area) GameInitError!void {
        for (areas_sorted) |area| {
            const area_coasts = area.coasts orelse continue;
            const land = try self.landByName(area.name);
            for (area_coasts) |coast_name| {
                const coast = try self.coastByName(coast_name);
                map.coast_owners[coast.id] = land;
            }
        }
    }

    fn fillEdges(self: NamesData, map: *dip.Map, pairs: []const Pair) GameInitError!void {
        for (pairs, 0..) |pair, i| {
            const p1 = try self.provinceByName(pair[0]);
            const p2 = try self.provinceByName(pair[1]);
            if (p1 == .land and p2 != .land or p1 != .land and p2 == .land) return error.IllegalBorder;
            map.pairs[i] = .{ p1, p2 };
        }
    }

    fn fillSortedAreas(self: NamesData, map: *dip.Map, areas_sorted: []const Area) GameInitError!void {
        for (areas_sorted, 0..) |area, i| {
            map.sorted_areas[i] = try self.provinceByName(area.name);
        }
    }
};
