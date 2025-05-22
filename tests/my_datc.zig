const std = @import("std");
const dip = @import("dip");
const dip_names = @import("dip_names");
const classic = @import("classic");
const datc = @import("datc.zig");

// These are some more tests I came up with.
// These tests are more closely related to the implementation than DATC.
// Ideally, more tests should be written.

test "Option: Missing commands" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);

        game.options.missing_orders = .issue_defaults;

        try game.adjudicateSpring();

        for (game.units.items) |unit| {
            try std.testing.expect(unit.command.? == .hold);
        }
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);

        game.options.missing_orders = .throw_error;

        try std.testing.expectError(error.NoOrder, game.adjudicateSpring());
    }
}

test "Option: Missing retreats" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try datc.createArmyAt(names, &game, "England", "Liverpool");
    try datc.createFleetAt(names, &game, "England", "Yorkshire");
    try datc.createFleetAt(names, &game, "England", "Norway");
    try datc.createArmyAt(names, &game, "Germany", "Kiel");
    try datc.createArmyAt(names, &game, "Germany", "Ruhr");
    try datc.createFleetAt(names, &game, "Russia", "Edinburgh");
    try datc.createArmyAt(names, &game, "Russia", "Sweden");
    try datc.createArmyAt(names, &game, "Russia", "Finland");
    try datc.createFleetAt(names, &game, "Russia", "Holland");

    try datc.issueMove(names, &game, "England", "Liverpool", "Edinburgh");
    try datc.issueSupportMove(names, &game, "England", "Yorkshire", "Liverpool", "Edinburgh");
    try datc.issueHold(names, &game, "England", "Norway");
    try datc.issueSupportMove(names, &game, "Germany", "Kiel", "Ruhr", "Holland");
    try datc.issueMove(names, &game, "Germany", "Ruhr", "Holland");
    try datc.issueHold(names, &game, "Russia", "Edinburgh");
    try datc.issueSupportMove(names, &game, "Russia", "Sweden", "Finland", "Norway");
    try datc.issueMove(names, &game, "Russia", "Finland", "Norway");
    try datc.issueHold(names, &game, "Russia", "Holland");

    try game.adjudicateSpring();

    game.options.missing_orders = .throw_error;

    try std.testing.expectError(error.NoOrder, game.adjudicateSpringRetreats());

    game.options.missing_orders = .issue_defaults;

    try game.adjudicateSpringRetreats();

    try std.testing.expect(game.retreats.items.len == 3);
    for (game.retreats.items) |retreat| {
        try std.testing.expect(retreat.to == null);
    }

    try game.stepSpring();

    try std.testing.expect(game.units.items.len == 6);
    try datc.expectUnitAtArea(game, names, "Russia", "Norway");
    try datc.expectUnitAtArea(game, names, "Germany", "Holland");
    try datc.expectUnitAtArea(game, names, "England", "Edinburgh");
    try datc.expectUnitAtArea(game, names, "Russia", "Sweden");
    try datc.expectUnitAtArea(game, names, "Germany", "Kiel");
    try datc.expectUnitAtArea(game, names, "England", "Yorkshire");
}

test "Option: Missing builds" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.season = .winter;
    game.units.items.len = 0;

    try game.adjudicateWinter();
    try std.testing.expect(game.units.items.len == 0);
}

test "Option: Missing disbands" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.season = .winter;
    for (game.supply_centers) |*sc| {
        sc.owner = null;
    }

    game.options.missing_orders = .throw_error;

    try std.testing.expectError(error.NoOrder, game.adjudicateWinter());

    game.options.missing_orders = .issue_defaults;

    try game.adjudicateWinter();
    try game.stepWinter();

    try std.testing.expect(game.units.items.len == 0);
}

test "Option: Illegal commands to hold" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.illegal_commands = .convert_to_hold;

    for (game.units.items) |unit| {
        try game.issueCommandAt(unit.country, unit.province, .{ .move = .{ .to = try names.provinceByName("Portugal") } });
        try std.testing.expect(unit.command.? != .hold);
    }

    try game.adjudicateSpring();

    for (game.units.items) |unit| {
        try std.testing.expect(unit.command.? == .hold);
    }
}

test "Option: Illegal retreat to disband" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.illegal_retreats = .convert_to_disband;

    try datc.createArmyAt(names, &game, "England", "Liverpool");
    try datc.createFleetAt(names, &game, "England", "Yorkshire");
    try datc.createFleetAt(names, &game, "England", "Norway");
    try datc.createArmyAt(names, &game, "Germany", "Kiel");
    try datc.createArmyAt(names, &game, "Germany", "Ruhr");
    try datc.createFleetAt(names, &game, "Russia", "Edinburgh");
    try datc.createArmyAt(names, &game, "Russia", "Sweden");
    try datc.createArmyAt(names, &game, "Russia", "Finland");
    try datc.createFleetAt(names, &game, "Russia", "Holland");

    try datc.issueMove(names, &game, "England", "Liverpool", "Edinburgh");
    try datc.issueSupportMove(names, &game, "England", "Yorkshire", "Liverpool", "Edinburgh");
    try datc.issueHold(names, &game, "England", "Norway");
    try datc.issueSupportMove(names, &game, "Germany", "Kiel", "Ruhr", "Holland");
    try datc.issueMove(names, &game, "Germany", "Ruhr", "Holland");
    try datc.issueHold(names, &game, "Russia", "Edinburgh");
    try datc.issueSupportMove(names, &game, "Russia", "Sweden", "Finland", "Norway");
    try datc.issueMove(names, &game, "Russia", "Finland", "Norway");
    try datc.issueHold(names, &game, "Russia", "Holland");

    try game.adjudicateSpring();

    try datc.issueRetreat(names, &game, "England", "Norway", "Portugal");
    try datc.issueRetreat(names, &game, "Russia", "Edinburgh", "Portugal");
    try datc.issueRetreat(names, &game, "Russia", "Holland", "Portugal");

    for (game.retreats.items) |retreat| {
        try std.testing.expect(retreat.to != null);
    }

    try game.adjudicateSpringRetreats();

    for (game.retreats.items) |retreat| {
        try std.testing.expect(retreat.to == null);
    }
}

test "Option: Duplicate commands" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);

        game.options.duplicate_orders = .throw_error;

        const warsaw = try names.provinceByName("Warsaw");

        try datc.issueMove(names, &game, "Russia", "Warsaw", "Galicia");
        try std.testing.expect(std.meta.eql(game.units.items[game.unitIdxAt(warsaw).?].command.?.move.to, try names.provinceByName("Galicia")));
        try std.testing.expectError(error.DuplicateOrder, datc.issueMove(names, &game, "Russia", "Warsaw", "Ukraine"));
        try std.testing.expectError(error.DuplicateOrder, datc.issueMove(names, &game, "Russia", "Warsaw", "Silesia"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);

        game.options.duplicate_orders = .overwrite;

        const warsaw = try names.provinceByName("Warsaw");

        try datc.issueMove(names, &game, "Russia", "Warsaw", "Galicia");
        try std.testing.expect(std.meta.eql(game.units.items[game.unitIdxAt(warsaw).?].command.?.move.to, try names.provinceByName("Galicia")));
        try datc.issueMove(names, &game, "Russia", "Warsaw", "Ukraine");
        try std.testing.expect(std.meta.eql(game.units.items[game.unitIdxAt(warsaw).?].command.?.move.to, try names.provinceByName("Ukraine")));
        try datc.issueMove(names, &game, "Russia", "Warsaw", "Silesia");
        try std.testing.expect(std.meta.eql(game.units.items[game.unitIdxAt(warsaw).?].command.?.move.to, try names.provinceByName("Silesia")));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);

        game.options.duplicate_orders = .ignore;

        const warsaw = try names.provinceByName("Warsaw");

        try datc.issueMove(names, &game, "Russia", "Warsaw", "Galicia");
        try std.testing.expect(std.meta.eql(game.units.items[game.unitIdxAt(warsaw).?].command.?.move.to, try names.provinceByName("Galicia")));
        try datc.issueMove(names, &game, "Russia", "Warsaw", "Ukraine");
        try std.testing.expect(std.meta.eql(game.units.items[game.unitIdxAt(warsaw).?].command.?.move.to, try names.provinceByName("Galicia")));
        try datc.issueMove(names, &game, "Russia", "Warsaw", "Silesia");
        try std.testing.expect(std.meta.eql(game.units.items[game.unitIdxAt(warsaw).?].command.?.move.to, try names.provinceByName("Galicia")));
    }
}

test "Option: Duplicate Retreats" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .throw_error;

        try datc.createArmyAt(names, &game, "Russia", "Warsaw");
        try datc.createArmyAt(names, &game, "Russia", "Moscow");
        try datc.createArmyAt(names, &game, "Turkey", "Ukraine");

        try datc.issueMove(names, &game, "Russia", "Warsaw", "Ukraine");
        try datc.issueSupportMove(names, &game, "Russia", "Moscow", "Warsaw", "Ukraine");
        try datc.issueHold(names, &game, "Turkey", "Ukraine");

        try game.adjudicateSpring();

        try datc.issueRetreat(names, &game, "Turkey", "Ukraine", "Galicia");
        try std.testing.expect(game.retreats.items.len == 1);
        try std.testing.expect(std.meta.eql(game.retreats.items[0].to, try names.provinceByName("Galicia")));
        try std.testing.expectError(error.DuplicateOrder, datc.issueRetreat(names, &game, "Turkey", "Ukraine", "Rumania"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .overwrite;

        try datc.createArmyAt(names, &game, "Russia", "Warsaw");
        try datc.createArmyAt(names, &game, "Russia", "Moscow");
        try datc.createArmyAt(names, &game, "Turkey", "Ukraine");

        try datc.issueMove(names, &game, "Russia", "Warsaw", "Ukraine");
        try datc.issueSupportMove(names, &game, "Russia", "Moscow", "Warsaw", "Ukraine");
        try datc.issueHold(names, &game, "Turkey", "Ukraine");

        try game.adjudicateSpring();

        try datc.issueRetreat(names, &game, "Turkey", "Ukraine", "Galicia");
        try std.testing.expect(game.retreats.items.len == 1);
        try std.testing.expect(std.meta.eql(game.retreats.items[0].to, try names.provinceByName("Galicia")));
        try datc.issueRetreat(names, &game, "Turkey", "Ukraine", "Rumania");
        try std.testing.expect(game.retreats.items.len == 1);
        try std.testing.expect(std.meta.eql(game.retreats.items[0].to, try names.provinceByName("Rumania")));
        try datc.issueRetreat(names, &game, "Turkey", "Ukraine", "Sevastopol");
        try std.testing.expect(game.retreats.items.len == 1);
        try std.testing.expect(std.meta.eql(game.retreats.items[0].to, try names.provinceByName("Sevastopol")));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .ignore;

        try datc.createArmyAt(names, &game, "Russia", "Warsaw");
        try datc.createArmyAt(names, &game, "Russia", "Moscow");
        try datc.createArmyAt(names, &game, "Turkey", "Ukraine");

        try datc.issueMove(names, &game, "Russia", "Warsaw", "Ukraine");
        try datc.issueSupportMove(names, &game, "Russia", "Moscow", "Warsaw", "Ukraine");
        try datc.issueHold(names, &game, "Turkey", "Ukraine");

        try game.adjudicateSpring();

        try datc.issueRetreat(names, &game, "Turkey", "Ukraine", "Galicia");
        try std.testing.expect(game.retreats.items.len == 1);
        try std.testing.expect(std.meta.eql(game.retreats.items[0].to, try names.provinceByName("Galicia")));
        try datc.issueRetreat(names, &game, "Turkey", "Ukraine", "Rumania");
        try std.testing.expect(game.retreats.items.len == 1);
        try std.testing.expect(std.meta.eql(game.retreats.items[0].to, try names.provinceByName("Galicia")));
        try datc.issueRetreat(names, &game, "Turkey", "Ukraine", "Sevastopol");
        try std.testing.expect(game.retreats.items.len == 1);
        try std.testing.expect(std.meta.eql(game.retreats.items[0].to, try names.provinceByName("Galicia")));
    }
}

test "Option: Duplicate Builds" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .throw_error;

        try datc.setSCOwner(names, &game, "Austria", "Trieste");
        try datc.setSCOwner(names, &game, "Austria", "Vienna");

        game.season = .winter;

        try datc.issueBuildArmy(names, &game, "Austria", "Trieste");
        try std.testing.expectError(error.DuplicateOrder, datc.issueBuildFleet(names, &game, "Austria", "Trieste"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .overwrite;

        try datc.setSCOwner(names, &game, "Austria", "Trieste");
        try datc.setSCOwner(names, &game, "Austria", "Vienna");

        game.season = .winter;

        try datc.issueBuildArmy(names, &game, "Austria", "Trieste");
        try datc.issueBuildFleet(names, &game, "Austria", "Trieste");

        try game.adjudicateWinter();
        try game.stepWinter();

        try datc.expectUnitAtProvince(game, names, "Austria", "Trieste Coast");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .ignore;

        try datc.setSCOwner(names, &game, "Austria", "Trieste");
        try datc.setSCOwner(names, &game, "Austria", "Vienna");

        game.season = .winter;

        try datc.issueBuildArmy(names, &game, "Austria", "Trieste");
        try datc.issueBuildFleet(names, &game, "Austria", "Trieste");

        try game.adjudicateWinter();
        try game.stepWinter();

        try datc.expectUnitAtProvince(game, names, "Austria", "Trieste");
    }
}

test "Option: Empty move" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);

        game.options.illegal_commands = .throw_error;
        game.options.move_to_self_is_hold = true;

        try datc.issueMove(names, &game, "Russia", "Warsaw", "Warsaw");

        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Warsaw")).?].command.? == .hold);
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);

        game.options.illegal_commands = .treat_as_hold;
        game.options.move_to_self_is_hold = false;

        try datc.issueMove(names, &game, "Russia", "Warsaw", "Warsaw");

        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Warsaw")).?].command.? == .move);
    }
}

test "Option: Adapt move to convoy" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;
        game.options.move_to_convoy = .illegal_to_legal;

        try datc.createFleetAt(names, &game, "France", "North Sea");
        try datc.createFleetAt(names, &game, "England", "Picardy");
        try datc.createArmyAt(names, &game, "England", "Yorkshire");
        try datc.createArmyAt(names, &game, "England", "Liverpool");
        try datc.createArmyAt(names, &game, "England", "Holland");

        try datc.issueMove(names, &game, "England", "Picardy", "Belgium");
        try datc.issueMove(names, &game, "England", "Yorkshire", "Belgium");
        try datc.issueMove(names, &game, "England", "Liverpool", "Belgium");
        try datc.issueMove(names, &game, "England", "Holland", "Belgium");
        try datc.issueHold(names, &game, "France", "North Sea");

        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Picardy")).?].command.? == .move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Yorkshire")).?].command.? == .convoy_move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Liverpool")).?].command.? == .move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Holland")).?].command.? == .move);
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;
        game.options.move_to_convoy = .always;

        try datc.createFleetAt(names, &game, "France", "North Sea");
        try datc.createFleetAt(names, &game, "England", "Picardy");
        try datc.createArmyAt(names, &game, "England", "Yorkshire");
        try datc.createArmyAt(names, &game, "England", "Liverpool");
        try datc.createArmyAt(names, &game, "England", "Holland");

        try datc.issueMove(names, &game, "England", "Picardy", "Belgium");
        try datc.issueMove(names, &game, "England", "Yorkshire", "Belgium");
        try datc.issueMove(names, &game, "England", "Liverpool", "Belgium");
        try datc.issueMove(names, &game, "England", "Holland", "Belgium");
        try datc.issueHold(names, &game, "France", "North Sea");

        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Picardy")).?].command.? == .move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Yorkshire")).?].command.? == .convoy_move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Liverpool")).?].command.? == .convoy_move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Holland")).?].command.? == .convoy_move);
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;
        game.options.move_to_convoy = .never;

        try datc.createFleetAt(names, &game, "France", "North Sea");
        try datc.createFleetAt(names, &game, "England", "Picardy");
        try datc.createArmyAt(names, &game, "England", "Yorkshire");
        try datc.createArmyAt(names, &game, "England", "Liverpool");
        try datc.createArmyAt(names, &game, "England", "Holland");

        try datc.issueMove(names, &game, "England", "Picardy", "Belgium");
        try datc.issueMove(names, &game, "England", "Yorkshire", "Belgium");
        try datc.issueMove(names, &game, "England", "Liverpool", "Belgium");
        try datc.issueMove(names, &game, "England", "Holland", "Belgium");
        try datc.issueHold(names, &game, "France", "North Sea");

        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Picardy")).?].command.? == .move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Yorkshire")).?].command.? == .move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Liverpool")).?].command.? == .move);
        try std.testing.expect(game.units.items[game.unitIdxAtArea(try names.provinceByName("Holland")).?].command.? == .move);
    }
}
