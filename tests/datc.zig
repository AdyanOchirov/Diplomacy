const std = @import("std");
const dip = @import("dip");
const dip_names = @import("dip_names");
const classic = @import("classic");

pub fn setSCOwner(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, land_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const land = try names.landByName(land_name);
    try game.setSCOwner(country, land);
}

pub fn createUnitAt(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.createUnitAt(country, province);
}

pub fn createArmyAt(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.createArmyAt(country, province);
}

pub fn createFleetAt(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.createFleetAt(country, province);
}

pub fn issueHold(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.issueCommandAt(country, province, .{ .hold = .{} });
}

pub fn issueMove(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name, to_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    const to = try names.provinceByName(to_name);
    try game.issueCommandAt(country, province, .{ .move = .{ .to = to } });
}

pub fn issueConvoyMove(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name, to_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    const to = try names.provinceByName(to_name);
    try game.issueCommandAt(country, province, .{ .convoy_move = .{ .to = to } });
}

pub fn issueSupportHold(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name, at_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    const at = try names.provinceByName(at_name);
    try game.issueCommandAt(country, province, .{ .support_hold = .{ .at = at } });
}

pub fn issueSupportMove(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name, from_name: dip_names.Name, to_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    const from = try names.provinceByName(from_name);
    const to = try names.provinceByName(to_name);
    try game.issueCommandAt(country, province, .{ .support_move = .{ .from = from, .to = to } });
}

pub fn issueConvoyTransport(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name, from_name: dip_names.Name, to_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    const from = try names.provinceByName(from_name);
    const to = try names.provinceByName(to_name);
    try game.issueCommandAt(country, province, .{ .convoy_transport = .{ .from = from, .to = to } });
}

pub fn issueRetreat(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name, to_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    const to = try names.provinceByName(to_name);
    try game.issueRetreatAt(country, province, to);
}

pub fn issueRetreatDisband(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.issueRetreatAt(country, province, null);
}

pub fn issueBuild(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.issueBuild(country, province);
}

pub fn issueBuildArmy(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.issueBuildArmy(country, province);
}

pub fn issueBuildFleet(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.issueBuildFleet(country, province);
}

pub fn issueDisband(names: dip_names.NamesData, game: *dip.Game, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    try game.issueDisbandAt(country, province);
}

/// Checks that there is only one unit in the given province and it is of matching country.
/// Used when it is important to know which coast the fleet is on.
pub fn expectUnitAtProvince(game: dip.Game, names: dip_names.NamesData, country_name: dip_names.Name, province_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const province = try names.provinceByName(province_name);
    var count: usize = 0;
    for (game.units.items) |unit| {
        if (std.meta.eql(unit.province, province)) {
            if (std.meta.eql(unit.country, country)) {
                count += 1;
            } else return error.AnotherUnit;
        }
    }
    if (count == 0) return error.NoUnit;
    if (count > 1) return error.MultipleUnits;
}

/// Checks that there is only one unit in the given area and it is of matching country.
pub fn expectUnitAtArea(game: dip.Game, names: dip_names.NamesData, country_name: dip_names.Name, area_name: dip_names.Name) !void {
    const country = try names.countryByName(country_name);
    const area = try names.provinceByName(area_name);
    var count: usize = 0;
    for (game.units.items) |unit| {
        if (game.map.sameArea(unit.province, area)) {
            if (std.meta.eql(unit.country, country)) {
                count += 1;
            } else return error.AnotherUnit;
        }
    }
    if (count == 0) return error.NoUnit;
    if (count > 1) return error.MultipleUnits;
}

/// Checks that there are no units in the given area.
pub fn expectEmptyAtArea(game: dip.Game, names: dip_names.NamesData, area_name: dip_names.Name) !void {
    const area = try names.provinceByName(area_name);
    for (game.units.items) |unit| {
        if (game.map.sameArea(unit.province, area)) return error.UnitFound;
    }
}

// This tests are taken from "https://www.webdiplomacy.net/doc/DATC_v3_0.html#6"
// Some tests have multiple outcomes depinding on adjudicator options.
// In such cases the test may be repeated with different options.
// I try to change only the options that are directly being tested.
// Default options are made as strict as possible with one exception: `adapt_area` is set to `adapt`.
// It allows not to write "X Coast" every time dealing with fleets.
// It is done for convenience. The option is turned off when test requires that.

// 6.A. TEST CASES, BASIC CHECKS

test "6.A.1. TEST CASE, MOVING TO AN AREA THAT IS NOT A NEIGHBOUR" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "England", "North Sea");

        try std.testing.expectError(error.NoPath, issueMove(names, &game, "England", "North Sea", "Picardy"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "England", "North Sea");

        try issueMove(names, &game, "England", "North Sea", "Picardy"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "North Sea");
        try expectEmptyAtArea(game, names, "Picardy");
    }
}

test "6.A.2. TEST CASE, MOVE ARMY TO SEA" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createArmyAt(names, &game, "England", "Liverpool");

        try std.testing.expectError(error.WrongAreaType, issueMove(names, &game, "England", "Liverpool", "Irish Sea"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createArmyAt(names, &game, "England", "Liverpool");

        try issueMove(names, &game, "England", "Liverpool", "Irish Sea"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "Liverpool");
        try expectEmptyAtArea(game, names, "Irish Sea");
    }
}

test "6.A.3. TEST CASE, MOVE FLEET TO LAND" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "Germany", "Kiel");

        try std.testing.expectError(error.WrongAreaType, issueMove(names, &game, "Germany", "Kiel", "Munich"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "Germany", "Kiel");

        try issueMove(names, &game, "Germany", "Kiel", "Munich"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Germany", "Kiel");
        try expectEmptyAtArea(game, names, "Munich");
    }
}

test "6.A.4. TEST CASE, MOVE TO OWN SECTOR" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createArmyAt(names, &game, "Germany", "Kiel");

        try std.testing.expectError(error.NoPath, issueMove(names, &game, "Germany", "Kiel", "Kiel"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createArmyAt(names, &game, "Germany", "Kiel");

        try issueMove(names, &game, "Germany", "Kiel", "Kiel"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Germany", "Kiel");
    }
}

test "6.A.5. TEST CASE, MOVE TO OWN SECTOR WITH CONVOY" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;
        game.options.move_to_self_is_hold = false;

        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Yorkshire");
        try createArmyAt(names, &game, "England", "Liverpool");

        try std.testing.expectError(error.NoPath, issueConvoyMove(names, &game, "England", "Yorkshire", "Yorkshire"));
        try std.testing.expectError(error.TransportNoPath, issueConvoyTransport(names, &game, "England", "North Sea", "Yorkshire", "Yorkshire"));
        try std.testing.expectError(error.SupportNoPath, issueSupportMove(names, &game, "England", "Liverpool", "Yorkshire", "Yorkshire"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;
        game.options.move_to_self_is_hold = false;

        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Yorkshire");
        try createArmyAt(names, &game, "England", "Liverpool");
        try createFleetAt(names, &game, "Germany", "London");
        try createArmyAt(names, &game, "Germany", "Wales");

        try issueConvoyMove(names, &game, "England", "Yorkshire", "Yorkshire"); // Illegal
        try issueConvoyTransport(names, &game, "England", "North Sea", "Yorkshire", "Yorkshire"); // Illegal
        try issueSupportMove(names, &game, "England", "Liverpool", "Yorkshire", "Yorkshire"); // Illegal
        try issueMove(names, &game, "Germany", "London", "Yorkshire");
        try issueSupportMove(names, &game, "Germany", "Wales", "London", "Yorkshire");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "England", "Yorkshire");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Germany", "Yorkshire");
        try expectEmptyAtArea(game, names, "London");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;
        game.options.move_to_self_is_hold = true;

        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Yorkshire");
        try createArmyAt(names, &game, "England", "Liverpool");
        try createFleetAt(names, &game, "Germany", "London");
        try createArmyAt(names, &game, "Germany", "Wales");

        try issueConvoyMove(names, &game, "England", "Yorkshire", "Yorkshire"); // Converted
        try issueConvoyTransport(names, &game, "England", "North Sea", "Yorkshire", "Yorkshire"); // Still just illegal
        try issueSupportMove(names, &game, "England", "Liverpool", "Yorkshire", "Yorkshire"); // Converted
        try issueMove(names, &game, "Germany", "London", "Yorkshire");
        try issueSupportMove(names, &game, "Germany", "Wales", "London", "Yorkshire");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "Yorkshire");
        try expectUnitAtArea(game, names, "Germany", "London");
    }
}

test "6.A.6. TEST CASE, ORDERING A UNIT OF ANOTHER COUNTRY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "London");

    try std.testing.expectError(error.WrongCountry, issueMove(names, &game, "Germany", "London", "North Sea"));
}

test "6.A.7. TEST CASE, ONLY ARMIES CAN BE CONVOYED" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "England", "London");
        try createFleetAt(names, &game, "England", "North Sea");

        try std.testing.expectError(error.WrongType, issueConvoyMove(names, &game, "England", "London", "Belgium"));
        try std.testing.expectError(error.WrongType, issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "England", "London");
        try createFleetAt(names, &game, "England", "North Sea");

        try issueConvoyMove(names, &game, "England", "London", "Belgium"); // Illegal
        try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "London");
        try expectEmptyAtArea(game, names, "Belgium");
    }
}

test "6.A.8. TEST CASE, SUPPORT TO HOLD YOURSELF IS NOT POSSIBLE" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "Austria", "Trieste");

        try std.testing.expectError(error.CantSupport, issueSupportHold(names, &game, "Austria", "Trieste", "Trieste"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "Austria", "Trieste");
        try createArmyAt(names, &game, "Italy", "Venice");
        try createArmyAt(names, &game, "Italy", "Tyrolia");

        try issueSupportHold(names, &game, "Austria", "Trieste", "Trieste"); // Illegal
        try issueMove(names, &game, "Italy", "Venice", "Trieste");
        try issueSupportMove(names, &game, "Italy", "Tyrolia", "Venice", "Trieste");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "Austria", "Trieste");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Italy", "Trieste");
        try expectEmptyAtArea(game, names, "Venice");
    }
}

test "6.A.9. TEST CASE, FLEETS MUST FOLLOW COAST IF NOT ON SEA" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "Italy", "Rome");

        try std.testing.expectError(error.NoPath, issueMove(names, &game, "Italy", "Rome", "Venice"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "Italy", "Rome");

        try issueMove(names, &game, "Italy", "Rome", "Venice"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Italy", "Rome");
        try expectEmptyAtArea(game, names, "Venice");
    }
}

test "6.A.10. TEST CASE, SUPPORT ON UNREACHABLE DESTINATION NOT POSSIBLE" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "Italy", "Rome");
        try createArmyAt(names, &game, "Italy", "Apulia");

        try issueMove(names, &game, "Italy", "Apulia", "Venice");
        try std.testing.expectError(error.CantSupport, issueSupportMove(names, &game, "Italy", "Rome", "Apulia", "Venice"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createArmyAt(names, &game, "Austria", "Venice");
        try createFleetAt(names, &game, "Italy", "Rome");
        try createArmyAt(names, &game, "Italy", "Apulia");

        try issueHold(names, &game, "Austria", "Venice");
        try issueSupportMove(names, &game, "Italy", "Rome", "Apulia", "Venice"); // Illegal
        try issueMove(names, &game, "Italy", "Apulia", "Venice");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Austria", "Venice");
        try expectUnitAtArea(game, names, "Italy", "Apulia");
    }
}

test "6.A.11. TEST CASE, SIMPLE BOUNCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Austria", "Vienna");
    try createArmyAt(names, &game, "Italy", "Venice");

    try issueMove(names, &game, "Austria", "Vienna", "Tyrolia");
    try issueMove(names, &game, "Italy", "Venice", "Tyrolia");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Vienna");
    try expectUnitAtArea(game, names, "Italy", "Venice");
    try expectEmptyAtArea(game, names, "Tyrolia");
}

test "6.A.12. TEST CASE, BOUNCE OF THREE UNITS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Austria", "Vienna");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createArmyAt(names, &game, "Germany", "Munich");

    try issueMove(names, &game, "Austria", "Vienna", "Tyrolia");
    try issueMove(names, &game, "Italy", "Venice", "Tyrolia");
    try issueMove(names, &game, "Germany", "Munich", "Tyrolia");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Vienna");
    try expectUnitAtArea(game, names, "Italy", "Venice");
    try expectUnitAtArea(game, names, "Germany", "Munich");
    try expectEmptyAtArea(game, names, "Tyrolia");
}

// 6.B. TEST CASES, COASTAL ISSUES

test "6.B.1. TEST CASE, MOVING WITH UNSPECIFIED COAST WHEN COAST IS NECESSARY" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "France", "Portugal");

        try std.testing.expectError(error.CantInferCoast, issueMove(names, &game, "France", "Portugal", "Spain"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "France", "Portugal");

        try issueMove(names, &game, "France", "Portugal", "Spain"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Portugal");
        try expectEmptyAtArea(game, names, "Spain");
    }
}

test "6.B.2. TEST CASE, MOVING WITH UNSPECIFIED COAST WHEN COAST IS NOT NECESSARY" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .ignore;

        try createFleetAt(names, &game, "France", "Gascony Coast");

        try std.testing.expectError(error.WrongAreaType, issueMove(names, &game, "France", "Gascony Coast", "Spain"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .adapt;

        try createFleetAt(names, &game, "France", "Gascony");

        try issueMove(names, &game, "France", "Gascony", "Spain");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtProvince(game, names, "France", "Spain North Coast");
        try expectEmptyAtArea(game, names, "Gascony");
    }
}

test "6.B.3. TEST CASE, MOVING WITH WRONG COAST WHEN COAST IS NOT NECESSARY" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;
        game.options.adapt_area = .adapt;

        try createFleetAt(names, &game, "France", "Gascony");

        try std.testing.expectError(error.NoPath, issueMove(names, &game, "France", "Gascony", "Spain South Coast"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;
        game.options.adapt_area = .adapt;

        try createFleetAt(names, &game, "France", "Gascony");

        try issueMove(names, &game, "France", "Gascony", "Spain South Coast"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Gascony");
        try expectEmptyAtArea(game, names, "Spain");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;
        game.options.adapt_area = .adapt_across_coasts;

        try createFleetAt(names, &game, "France", "Gascony");

        try issueMove(names, &game, "France", "Gascony", "Spain South Coast"); // Converted

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtProvince(game, names, "France", "Spain North Coast");
        try expectEmptyAtArea(game, names, "Gascony");
    }
}

test "6.B.4. TEST CASE, SUPPORT TO UNREACHABLE COAST ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "France", "Gascony");
    try createFleetAt(names, &game, "France", "Marseilles");
    try createFleetAt(names, &game, "Italy", "Western Mediterranean Sea");

    try issueMove(names, &game, "France", "Gascony", "Spain North Coast");
    try issueSupportMove(names, &game, "France", "Marseilles", "Gascony", "Spain North Coast");
    try issueMove(names, &game, "Italy", "Western Mediterranean Sea", "Spain South Coast");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtProvince(game, names, "France", "Spain North Coast");
    try expectUnitAtArea(game, names, "Italy", "Western Mediterranean Sea");
    try expectEmptyAtArea(game, names, "Gascony");
}

test "6.B.5. TEST CASE, SUPPORT FROM UNREACHABLE COAST NOT ALLOWED" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "France", "Marseilles");
        try createFleetAt(names, &game, "France", "Spain North Coast");

        try issueMove(names, &game, "France", "Marseilles", "Gulf of Lyon");
        try std.testing.expectError(error.CantSupport, issueSupportMove(names, &game, "France", "Spain", "Marseilles", "Gulf of Lyon"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "France", "Marseilles");
        try createFleetAt(names, &game, "France", "Spain North Coast");
        try createFleetAt(names, &game, "Italy", "Gulf of Lyon");

        try issueMove(names, &game, "France", "Marseilles", "Gulf of Lyon");
        try issueSupportMove(names, &game, "France", "Spain North Coast", "Marseilles", "Gulf of Lyon"); // Illegal
        try issueHold(names, &game, "Italy", "Gulf of Lyon");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Marseilles");
        try expectUnitAtArea(game, names, "Italy", "Gulf of Lyon");
    }
}

test "6.B.6. TEST CASE, SUPPORT CAN BE CUT WITH OTHER COAST" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "Irish Sea");
    try createFleetAt(names, &game, "England", "North Atlantic Ocean");
    try createFleetAt(names, &game, "France", "Spain North Coast");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
    try createFleetAt(names, &game, "Italy", "Gulf of Lyon");

    try issueSupportMove(names, &game, "England", "Irish Sea", "North Atlantic Ocean", "Mid-Atlantic Ocean");
    try issueMove(names, &game, "England", "North Atlantic Ocean", "Mid-Atlantic Ocean");
    try issueSupportHold(names, &game, "France", "Spain", "Mid-Atlantic Ocean");
    try issueHold(names, &game, "France", "Mid-Atlantic Ocean");
    try issueMove(names, &game, "Italy", "Gulf of Lyon", "Spain");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "France", "Mid-Atlantic Ocean");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Mid-Atlantic Ocean");
    try expectUnitAtArea(game, names, "Italy", "Gulf of Lyon");
    try expectEmptyAtArea(game, names, "North Atlantic Ocean");
}

test "6.B.7. TEST CASE, SUPPORTING OWN UNIT WITH UNSPECIFIED COAST" {
    // Could add option for matching support. Would only work with illegal commands enabled.
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "France", "Portugal");
        try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");

        try std.testing.expectError(error.CantInferCoast, issueSupportMove(names, &game, "France", "Portugal", "Mid-Atlantic Ocean", "Spain"));
        try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "Spain North Coast");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "France", "Portugal");
        try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
        try createFleetAt(names, &game, "Italy", "Western Mediterranean Sea");
        try createFleetAt(names, &game, "Italy", "Gulf of Lyon");

        try issueSupportMove(names, &game, "France", "Portugal", "Mid-Atlantic Ocean", "Spain"); // Illegal
        try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "Spain North Coast");
        try issueMove(names, &game, "Italy", "Western Mediterranean Sea", "Spain South Coast");
        try issueSupportMove(names, &game, "Italy", "Gulf of Lyon", "Western Mediterranean Sea", "Spain South Coast");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtProvince(game, names, "Italy", "Spain South Coast");
        try expectUnitAtArea(game, names, "France", "Mid-Atlantic Ocean");
    }
}

test "6.B.8. TEST CASE, SUPPORTING WITH UNSPECIFIED COAST WHEN ONLY ONE COAST IS POSSIBLE" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .ignore;

        try createFleetAt(names, &game, "France", "Portugal Coast");
        try createFleetAt(names, &game, "France", "Gascony Coast");

        try std.testing.expectError(error.WrongAreaType, issueSupportMove(names, &game, "France", "Portugal Coast", "Gascony Coast", "Spain"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .adapt;

        try createFleetAt(names, &game, "France", "Portugal");
        try createFleetAt(names, &game, "France", "Gascony");
        try createFleetAt(names, &game, "Italy", "Gulf of Lyon");
        try createFleetAt(names, &game, "Italy", "Western Mediterranean Sea");

        try issueSupportMove(names, &game, "France", "Portugal", "Gascony", "Spain");
        try issueMove(names, &game, "France", "Gascony", "Spain North Coast");
        try issueMove(names, &game, "Italy", "Western Mediterranean Sea", "Spain South Coast");
        try issueSupportMove(names, &game, "Italy", "Gulf of Lyon", "Western Mediterranean Sea", "Spain South Coast");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Italy", "Western Mediterranean Sea");
        try expectUnitAtArea(game, names, "France", "Gascony");
        try expectEmptyAtArea(game, names, "Spain");
    }
}

test "6.B.9. TEST CASE, SUPPORTING WITH WRONG COAST" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "France", "Portugal");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
    try createFleetAt(names, &game, "Italy", "Western Mediterranean Sea");
    try createFleetAt(names, &game, "Italy", "Gulf of Lyon");

    try issueSupportMove(names, &game, "France", "Portugal", "Mid-Atlantic Ocean", "Spain North Coast");
    try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "Spain South Coast");
    try issueSupportMove(names, &game, "Italy", "Gulf of Lyon", "Western Mediterranean Sea", "Spain South Coast");
    try issueMove(names, &game, "Italy", "Western Mediterranean Sea", "Spain South Coast");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtProvince(game, names, "Italy", "Spain South Coast");
    try expectUnitAtArea(game, names, "France", "Mid-Atlantic Ocean");
    try expectEmptyAtArea(game, names, "Western Mediterranean Sea");
}

test "6.B.10. TEST CASE, UNIT ORDERED WITH WRONG COAST" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .ignore;

        try createFleetAt(names, &game, "France", "Spain South Coast");

        try std.testing.expectError(error.NoUnit, issueMove(names, &game, "France", "Spain North Coast", "Gulf of Lyon"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .adapt;

        try createFleetAt(names, &game, "France", "Spain South Coast");

        try issueMove(names, &game, "France", "Spain North Coast", "Gulf of Lyon");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Gulf of Lyon");
        try expectEmptyAtArea(game, names, "Spain");
    }
}

test "6.B.11. TEST CASE, COAST CANNOT BE ORDERED TO CHANGE" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .ignore;

        try createFleetAt(names, &game, "France", "Spain North Coast");

        try std.testing.expectError(error.NoUnit, issueMove(names, &game, "France", "Spain South Coast", "Gulf of Lyon"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .adapt;

        try createFleetAt(names, &game, "France", "Spain North Coast");

        try std.testing.expectError(error.NoPath, issueMove(names, &game, "France", "Spain South Coast", "Gulf of Lyon"));
    }
}

test "6.B.12. TEST CASE, ARMY MOVEMENT WITH COASTAL SPECIFICATION" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .ignore;

        try createArmyAt(names, &game, "France", "Gascony");

        try std.testing.expectError(error.WrongAreaType, issueMove(names, &game, "France", "Gascony", "Spain North Coast"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .adapt;

        try createArmyAt(names, &game, "France", "Gascony");

        try issueMove(names, &game, "France", "Gascony", "Spain North Coast");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Spain");
        try expectEmptyAtArea(game, names, "Gascony");
    }
}

test "6.B.13. TEST CASE, COASTAL CRAWL NOT ALLOWED" {
    // Countries changed for more contrast.
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Russia", "Bulgaria South Coast");
    try createFleetAt(names, &game, "Turkey", "Constantinople");

    try issueMove(names, &game, "Russia", "Bulgaria South Coast", "Constantinople");
    try issueMove(names, &game, "Turkey", "Constantinople", "Bulgaria East Coast");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtProvince(game, names, "Russia", "Bulgaria South Coast");
    try expectUnitAtArea(game, names, "Turkey", "Constantinople");
}

test "6.B.14. TEST CASE, BUILDING WITH UNSPECIFIED COAST" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try setSCOwner(names, &game, "Russia", "St. Petersburg");

    game.season = .winter;

    try std.testing.expectError(error.CantInferCoast, issueBuildFleet(names, &game, "Russia", "St. Petersburg"));
}

test "6.B.15. TEST CASE, SUPPORTING FOREIGN UNIT WITH UNSPECIFIED COAST" {
    // Could add option for matching support. Would only work with illegal commands enabled.
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "France", "Portugal");
        try createFleetAt(names, &game, "England", "Mid-Atlantic Ocean");

        try std.testing.expectError(error.CantInferCoast, issueSupportMove(names, &game, "France", "Portugal", "Mid-Atlantic Ocean", "Spain"));
        try issueMove(names, &game, "England", "Mid-Atlantic Ocean", "Spain North Coast");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "France", "Portugal");
        try createFleetAt(names, &game, "England", "Mid-Atlantic Ocean");
        try createFleetAt(names, &game, "Italy", "Western Mediterranean Sea");
        try createFleetAt(names, &game, "Italy", "Gulf of Lyon");

        try issueSupportMove(names, &game, "France", "Portugal", "Mid-Atlantic Ocean", "Spain"); // Illegal
        try issueMove(names, &game, "England", "Mid-Atlantic Ocean", "Spain North Coast");
        try issueMove(names, &game, "Italy", "Western Mediterranean Sea", "Spain South Coast");
        try issueSupportMove(names, &game, "Italy", "Gulf of Lyon", "Western Mediterranean Sea", "Spain South Coast");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtProvince(game, names, "Italy", "Spain South Coast");
        try expectUnitAtArea(game, names, "England", "Mid-Atlantic Ocean");
        try expectEmptyAtArea(game, names, "Western Mediterranean Sea");
    }
}

// 6.C. TEST CASES, CIRCULAR MOVEMENT

test "6.C.1. TEST CASE, THREE ARMY CIRCULAR MOVEMENT" {
    // Countries changed for more contrast.
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Russia", "Ankara");
    try createFleetAt(names, &game, "Turkey", "Constantinople");
    try createArmyAt(names, &game, "Italy", "Smyrna");

    try issueMove(names, &game, "Russia", "Ankara", "Constantinople");
    try issueMove(names, &game, "Turkey", "Constantinople", "Smyrna");
    try issueMove(names, &game, "Italy", "Smyrna", "Ankara");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Ankara");
    try expectUnitAtArea(game, names, "Russia", "Constantinople");
    try expectUnitAtArea(game, names, "Turkey", "Smyrna");
}

test "6.C.2. TEST CASE, THREE ARMY CIRCULAR MOVEMENT WITH SUPPORT" {
    // Countries changed for more contrast.
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Russia", "Ankara");
    try createArmyAt(names, &game, "Turkey", "Constantinople");
    try createArmyAt(names, &game, "Italy", "Smyrna");
    try createArmyAt(names, &game, "Austria", "Bulgaria");

    try issueMove(names, &game, "Russia", "Ankara", "Constantinople");
    try issueMove(names, &game, "Turkey", "Constantinople", "Smyrna");
    try issueMove(names, &game, "Italy", "Smyrna", "Ankara");
    try issueSupportMove(names, &game, "Austria", "Bulgaria", "Ankara", "Constantinople");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Ankara");
    try expectUnitAtArea(game, names, "Russia", "Constantinople");
    try expectUnitAtArea(game, names, "Turkey", "Smyrna");
    try expectUnitAtArea(game, names, "Austria", "Bulgaria");
}

test "6.C.3. TEST CASE, A DISRUPTED THREE ARMY CIRCULAR MOVEMENT" {
    // Countries changed for more contrast.
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Russia", "Ankara");
    try createArmyAt(names, &game, "Turkey", "Constantinople");
    try createArmyAt(names, &game, "Italy", "Smyrna");
    try createArmyAt(names, &game, "Austria", "Bulgaria");

    try issueMove(names, &game, "Russia", "Ankara", "Constantinople");
    try issueMove(names, &game, "Turkey", "Constantinople", "Smyrna");
    try issueMove(names, &game, "Italy", "Smyrna", "Ankara");
    try issueMove(names, &game, "Austria", "Bulgaria", "Constantinople");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Ankara");
    try expectUnitAtArea(game, names, "Turkey", "Constantinople");
    try expectUnitAtArea(game, names, "Italy", "Smyrna");
    try expectUnitAtArea(game, names, "Austria", "Bulgaria");
}

test "6.C.4. TEST CASE, A CIRCULAR MOVEMENT WITH ATTACKED CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Austria", "Serbia");
    try createArmyAt(names, &game, "Turkey", "Bulgaria");
    try createFleetAt(names, &game, "Turkey", "Aegean Sea");
    try createFleetAt(names, &game, "Turkey", "Ionian Sea");
    try createFleetAt(names, &game, "Turkey", "Adriatic Sea");
    try createFleetAt(names, &game, "Italy", "Naples");

    try issueMove(names, &game, "Austria", "Trieste", "Serbia");
    try issueMove(names, &game, "Austria", "Serbia", "Bulgaria");
    try issueConvoyMove(names, &game, "Turkey", "Bulgaria", "Trieste");
    try issueConvoyTransport(names, &game, "Turkey", "Aegean Sea", "Bulgaria", "Trieste");
    try issueConvoyTransport(names, &game, "Turkey", "Ionian Sea", "Bulgaria", "Trieste");
    try issueConvoyTransport(names, &game, "Turkey", "Adriatic Sea", "Bulgaria", "Trieste");
    try issueMove(names, &game, "Italy", "Naples", "Ionian Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Serbia");
    try expectUnitAtArea(game, names, "Austria", "Bulgaria");
    try expectUnitAtArea(game, names, "Turkey", "Trieste");
}

test "6.C.5. TEST CASE, A DISRUPTED CIRCULAR MOVEMENT DUE TO DISLODGED CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Austria", "Serbia");
    try createArmyAt(names, &game, "Turkey", "Bulgaria");
    try createFleetAt(names, &game, "Turkey", "Aegean Sea");
    try createFleetAt(names, &game, "Turkey", "Ionian Sea");
    try createFleetAt(names, &game, "Turkey", "Adriatic Sea");
    try createFleetAt(names, &game, "Italy", "Naples");
    try createFleetAt(names, &game, "Italy", "Tunis");

    try issueMove(names, &game, "Austria", "Trieste", "Serbia");
    try issueMove(names, &game, "Austria", "Serbia", "Bulgaria");
    try issueConvoyMove(names, &game, "Turkey", "Bulgaria", "Trieste");
    try issueConvoyTransport(names, &game, "Turkey", "Aegean Sea", "Bulgaria", "Trieste");
    try issueConvoyTransport(names, &game, "Turkey", "Ionian Sea", "Bulgaria", "Trieste");
    try issueConvoyTransport(names, &game, "Turkey", "Adriatic Sea", "Bulgaria", "Trieste");
    try issueMove(names, &game, "Italy", "Naples", "Ionian Sea");
    try issueSupportMove(names, &game, "Italy", "Tunis", "Naples", "Ionian Sea");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Turkey", "Ionian Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Trieste");
    try expectUnitAtArea(game, names, "Austria", "Serbia");
    try expectUnitAtArea(game, names, "Turkey", "Bulgaria");
}

test "6.C.6. TEST CASE, TWO ARMIES WITH TWO CONVOYS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createArmyAt(names, &game, "France", "Belgium");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "France", "English Channel");

    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium");
    try issueConvoyMove(names, &game, "France", "Belgium", "London");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Belgium", "London");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Belgium");
    try expectUnitAtArea(game, names, "France", "London");
}

test "6.C.7. TEST CASE, DISRUPTED UNIT SWAP" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createArmyAt(names, &game, "France", "Belgium");
    try createArmyAt(names, &game, "France", "Burgundy");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "France", "English Channel");

    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium");
    try issueConvoyMove(names, &game, "France", "Belgium", "London");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Belgium", "London");
    try issueMove(names, &game, "France", "Burgundy", "Belgium");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "London");
    try expectUnitAtArea(game, names, "France", "Belgium");
    try expectUnitAtArea(game, names, "France", "Burgundy");
}

test "6.C.8. TEST CASE, NO SELF DISLODGEMENT IN DISRUPTED CIRCULAR MOVEMENT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Turkey", "Constantinople");
    try createArmyAt(names, &game, "Turkey", "Bulgaria");
    try createArmyAt(names, &game, "Turkey", "Smyrna");
    try createFleetAt(names, &game, "Russia", "Black Sea");
    try createArmyAt(names, &game, "Austria", "Serbia");

    try issueMove(names, &game, "Turkey", "Constantinople", "Black Sea");
    try issueMove(names, &game, "Turkey", "Bulgaria", "Constantinople");
    try issueSupportMove(names, &game, "Turkey", "Smyrna", "Bulgaria", "Constantinople");
    try issueMove(names, &game, "Russia", "Black Sea", "Bulgaria");
    try issueMove(names, &game, "Austria", "Serbia", "Bulgaria");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Turkey", "Constantinople");
    try expectUnitAtArea(game, names, "Turkey", "Bulgaria");
    try expectUnitAtArea(game, names, "Russia", "Black Sea");
    try expectUnitAtArea(game, names, "Austria", "Serbia");
}

test "6.C.9. TEST CASE, NO HELP IN DISLODGEMENT OF OWN UNIT IN DISRUPTED CIRCULAR MOVEMENT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Turkey", "Constantinople");
    try createArmyAt(names, &game, "Turkey", "Smyrna");
    try createArmyAt(names, &game, "Turkey", "Bulgaria");
    try createFleetAt(names, &game, "Russia", "Black Sea");
    try createArmyAt(names, &game, "Austria", "Serbia");

    try issueMove(names, &game, "Turkey", "Constantinople", "Black Sea");
    try issueSupportMove(names, &game, "Turkey", "Smyrna", "Bulgaria", "Constantinople");
    try issueMove(names, &game, "Russia", "Black Sea", "Bulgaria");
    try issueMove(names, &game, "Austria", "Serbia", "Bulgaria");
    try issueMove(names, &game, "Turkey", "Bulgaria", "Constantinople");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Turkey", "Constantinople");
    try expectUnitAtArea(game, names, "Turkey", "Smyrna");
    try expectUnitAtArea(game, names, "Turkey", "Bulgaria");
    try expectUnitAtArea(game, names, "Russia", "Black Sea");
    try expectUnitAtArea(game, names, "Austria", "Serbia");
}

// 6.D. TEST CASES, SUPPORTS AND DISLODGES

test "6.D.1. TEST CASE, SUPPORTED HOLD CAN PREVENT DISLODGEMENT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Adriatic Sea");
    try createArmyAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createArmyAt(names, &game, "Italy", "Tyrolia");

    try issueSupportMove(names, &game, "Austria", "Adriatic Sea", "Trieste", "Venice");
    try issueMove(names, &game, "Austria", "Trieste", "Venice");
    try issueHold(names, &game, "Italy", "Venice");
    try issueSupportHold(names, &game, "Italy", "Tyrolia", "Venice");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Venice");
    try expectUnitAtArea(game, names, "Austria", "Trieste");
}

test "6.D.2. TEST CASE, A MOVE CUTS SUPPORT ON HOLD" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Adriatic Sea");
    try createArmyAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Austria", "Vienna");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createArmyAt(names, &game, "Italy", "Tyrolia");

    try issueSupportMove(names, &game, "Austria", "Adriatic Sea", "Trieste", "Venice");
    try issueMove(names, &game, "Austria", "Trieste", "Venice");
    try issueMove(names, &game, "Austria", "Vienna", "Tyrolia");
    try issueHold(names, &game, "Italy", "Venice");
    try issueSupportHold(names, &game, "Italy", "Tyrolia", "Venice");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Italy", "Venice");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Venice");
}

test "6.D.3. TEST CASE, A MOVE CUTS SUPPORT ON MOVE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Adriatic Sea");
    try createArmyAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createFleetAt(names, &game, "Italy", "Ionian Sea");

    try issueSupportMove(names, &game, "Austria", "Adriatic Sea", "Trieste", "Venice");
    try issueMove(names, &game, "Austria", "Trieste", "Venice");
    try issueHold(names, &game, "Italy", "Venice");
    try issueMove(names, &game, "Italy", "Ionian Sea", "Adriatic Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Venice");
    try expectUnitAtArea(game, names, "Austria", "Trieste");
}

test "6.D.4. TEST CASE, SUPPORT TO HOLD ON UNIT SUPPORTING A HOLD ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createFleetAt(names, &game, "Russia", "Baltic Sea");
    try createArmyAt(names, &game, "Russia", "Prussia");

    try issueSupportHold(names, &game, "Germany", "Berlin", "Kiel");
    try issueSupportHold(names, &game, "Germany", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "Russia", "Baltic Sea", "Prussia", "Berlin");
    try issueMove(names, &game, "Russia", "Prussia", "Berlin");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Berlin");
    try expectUnitAtArea(game, names, "Russia", "Prussia");
}

test "6.D.5. TEST CASE, SUPPORT TO HOLD ON UNIT SUPPORTING A MOVE ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Munich");
    try createFleetAt(names, &game, "Russia", "Baltic Sea");
    try createArmyAt(names, &game, "Russia", "Prussia");

    try issueSupportMove(names, &game, "Germany", "Berlin", "Munich", "Silesia");
    try issueSupportHold(names, &game, "Germany", "Kiel", "Berlin");
    try issueMove(names, &game, "Germany", "Munich", "Silesia");
    try issueSupportMove(names, &game, "Russia", "Baltic Sea", "Prussia", "Berlin");
    try issueMove(names, &game, "Russia", "Prussia", "Berlin");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Kiel");
    try expectUnitAtArea(game, names, "Germany", "Silesia");
    try expectUnitAtArea(game, names, "Russia", "Prussia");
}

test "6.D.6. TEST CASE, SUPPORT TO HOLD ON CONVOYING UNIT ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Baltic Sea");
    try createFleetAt(names, &game, "Germany", "Prussia");
    try createFleetAt(names, &game, "Russia", "Livonia");
    try createFleetAt(names, &game, "Russia", "Gulf of Bothnia");

    try issueConvoyMove(names, &game, "Germany", "Berlin", "Sweden");
    try issueConvoyTransport(names, &game, "Germany", "Baltic Sea", "Berlin", "Sweden");
    try issueSupportHold(names, &game, "Germany", "Prussia", "Baltic Sea");
    try issueMove(names, &game, "Russia", "Livonia", "Baltic Sea");
    try issueSupportMove(names, &game, "Russia", "Gulf of Bothnia", "Livonia", "Baltic Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Baltic Sea");
    try expectUnitAtArea(game, names, "Russia", "Livonia");
}

test "6.D.7. TEST CASE, SUPPORT TO HOLD ON MOVING UNIT NOT ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Germany", "Baltic Sea");
    try createFleetAt(names, &game, "Germany", "Prussia");
    try createFleetAt(names, &game, "Russia", "Livonia");
    try createFleetAt(names, &game, "Russia", "Gulf of Bothnia");
    try createArmyAt(names, &game, "Russia", "Finland");

    try issueMove(names, &game, "Germany", "Baltic Sea", "Sweden");
    try issueSupportHold(names, &game, "Germany", "Prussia", "Baltic Sea");
    try issueMove(names, &game, "Russia", "Livonia", "Baltic Sea");
    try issueSupportMove(names, &game, "Russia", "Gulf of Bothnia", "Livonia", "Baltic Sea");
    try issueMove(names, &game, "Russia", "Finland", "Sweden");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Germany", "Baltic Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Baltic Sea");
    try expectUnitAtArea(game, names, "Russia", "Finland");
}

test "6.D.8. TEST CASE, FAILED CONVOY CANNOT RECEIVE HOLD SUPPORT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Ionian Sea");
    try createArmyAt(names, &game, "Austria", "Serbia");
    try createArmyAt(names, &game, "Austria", "Albania");
    try createArmyAt(names, &game, "Turkey", "Greece");
    try createArmyAt(names, &game, "Turkey", "Bulgaria");

    try issueHold(names, &game, "Austria", "Ionian Sea");
    try issueSupportMove(names, &game, "Austria", "Serbia", "Albania", "Greece");
    try issueMove(names, &game, "Austria", "Albania", "Greece");
    try issueConvoyMove(names, &game, "Turkey", "Greece", "Naples");
    try issueSupportHold(names, &game, "Turkey", "Bulgaria", "Greece");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Turkey", "Greece");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Greece");
}

test "6.D.9. TEST CASE, SUPPORT TO MOVE ON HOLDING UNIT NOT ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Italy", "Venice");
    try createArmyAt(names, &game, "Italy", "Tyrolia");
    try createArmyAt(names, &game, "Austria", "Albania");
    try createArmyAt(names, &game, "Austria", "Trieste");

    try issueMove(names, &game, "Italy", "Venice", "Trieste");
    try issueSupportMove(names, &game, "Italy", "Tyrolia", "Venice", "Trieste");
    try issueSupportMove(names, &game, "Austria", "Albania", "Trieste", "Serbia");
    try issueHold(names, &game, "Austria", "Trieste");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Austria", "Trieste");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Trieste");
}

test "6.D.10. TEST CASE, SELF DISLODGMENT PROHIBITED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Munich");

    try issueHold(names, &game, "Germany", "Berlin");
    try issueMove(names, &game, "Germany", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "Germany", "Munich", "Kiel", "Berlin");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Kiel");
    try expectUnitAtArea(game, names, "Germany", "Berlin");
}

test "6.D.11. TEST CASE, NO SELF DISLODGMENT OF RETURNING UNIT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Munich");
    try createArmyAt(names, &game, "Russia", "Warsaw");

    try issueMove(names, &game, "Germany", "Berlin", "Prussia");
    try issueMove(names, &game, "Germany", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "Germany", "Munich", "Kiel", "Berlin");
    try issueMove(names, &game, "Russia", "Warsaw", "Prussia");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Warsaw");
    try expectUnitAtArea(game, names, "Germany", "Berlin");
    try expectUnitAtArea(game, names, "Germany", "Kiel");
}

test "6.D.12. TEST CASE, SUPPORTING A FOREIGN UNIT TO DISLODGE OWN UNIT PROHIBITED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Austria", "Vienna");
    try createArmyAt(names, &game, "Italy", "Venice");

    try issueHold(names, &game, "Austria", "Trieste");
    try issueSupportMove(names, &game, "Austria", "Vienna", "Venice", "Trieste");
    try issueMove(names, &game, "Italy", "Venice", "Trieste");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Venice");
    try expectUnitAtArea(game, names, "Austria", "Trieste");
}

test "6.D.13. TEST CASE, SUPPORTING A FOREIGN UNIT TO DISLODGE A RETURNING OWN UNIT PROHIBITED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Austria", "Vienna");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createFleetAt(names, &game, "Italy", "Apulia");

    try issueMove(names, &game, "Austria", "Trieste", "Adriatic Sea");
    try issueSupportMove(names, &game, "Austria", "Vienna", "Venice", "Trieste");
    try issueMove(names, &game, "Italy", "Venice", "Trieste");
    try issueMove(names, &game, "Italy", "Apulia", "Adriatic Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Trieste");
    try expectUnitAtArea(game, names, "Italy", "Venice");
    try expectUnitAtArea(game, names, "Italy", "Apulia");
}

test "6.D.14. TEST CASE, SUPPORTING A FOREIGN UNIT IS NOT ENOUGH TO PREVENT DISLODGEMENT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Austria", "Vienna");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createArmyAt(names, &game, "Italy", "Tyrolia");
    try createFleetAt(names, &game, "Italy", "Adriatic Sea");

    try issueHold(names, &game, "Austria", "Trieste");
    try issueSupportMove(names, &game, "Austria", "Vienna", "Venice", "Trieste");
    try issueMove(names, &game, "Italy", "Venice", "Trieste");
    try issueSupportMove(names, &game, "Italy", "Tyrolia", "Venice", "Trieste");
    try issueSupportMove(names, &game, "Italy", "Adriatic Sea", "Venice", "Trieste");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Austria", "Trieste");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Trieste");
}

test "6.D.15. TEST CASE, DEFENDER CANNOT CUT SUPPORT FOR ATTACK ON ITSELF" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Russia", "Constantinople");
    try createFleetAt(names, &game, "Russia", "Black Sea");
    try createFleetAt(names, &game, "Turkey", "Ankara");

    try issueSupportMove(names, &game, "Russia", "Constantinople", "Black Sea", "Ankara");
    try issueMove(names, &game, "Russia", "Black Sea", "Ankara");
    try issueMove(names, &game, "Turkey", "Ankara", "Constantinople");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Turkey", "Ankara");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Ankara");
}

test "6.D.16. TEST CASE, CONVOYING A UNIT DISLODGING A UNIT OF SAME POWER IS ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createArmyAt(names, &game, "France", "Belgium");
    try createFleetAt(names, &game, "France", "English Channel");

    try issueHold(names, &game, "England", "London");
    try issueConvoyTransport(names, &game, "England", "North Sea", "Belgium", "London");
    try issueSupportMove(names, &game, "France", "English Channel", "Belgium", "London");
    try issueConvoyMove(names, &game, "France", "Belgium", "London");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "London");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "London");
}

test "6.D.17. TEST CASE, DISLODGEMENT CUTS SUPPORTS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Russia", "Constantinople");
    try createFleetAt(names, &game, "Russia", "Black Sea");
    try createFleetAt(names, &game, "Turkey", "Ankara");
    try createArmyAt(names, &game, "Turkey", "Smyrna");
    try createArmyAt(names, &game, "Turkey", "Armenia");

    try issueSupportMove(names, &game, "Russia", "Constantinople", "Black Sea", "Ankara");
    try issueMove(names, &game, "Russia", "Black Sea", "Ankara");
    try issueMove(names, &game, "Turkey", "Ankara", "Constantinople");
    try issueSupportMove(names, &game, "Turkey", "Smyrna", "Ankara", "Constantinople");
    try issueMove(names, &game, "Turkey", "Armenia", "Ankara");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Russia", "Constantinople");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Black Sea");
    try expectUnitAtArea(game, names, "Turkey", "Constantinople");
    try expectUnitAtArea(game, names, "Turkey", "Armenia");
}

test "6.D.18. TEST CASE, A SURVIVING UNIT WILL SUSTAIN SUPPORT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Russia", "Constantinople");
    try createFleetAt(names, &game, "Russia", "Black Sea");
    try createArmyAt(names, &game, "Russia", "Bulgaria");
    try createFleetAt(names, &game, "Turkey", "Ankara");
    try createArmyAt(names, &game, "Turkey", "Smyrna");
    try createArmyAt(names, &game, "Turkey", "Armenia");

    try issueSupportMove(names, &game, "Russia", "Constantinople", "Black Sea", "Ankara");
    try issueMove(names, &game, "Russia", "Black Sea", "Ankara");
    try issueSupportHold(names, &game, "Russia", "Bulgaria", "Constantinople");
    try issueMove(names, &game, "Turkey", "Ankara", "Constantinople");
    try issueSupportMove(names, &game, "Turkey", "Smyrna", "Ankara", "Constantinople");
    try issueMove(names, &game, "Turkey", "Armenia", "Ankara");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Turkey", "Ankara");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Constantinople");
    try expectUnitAtArea(game, names, "Russia", "Ankara");
    try expectUnitAtArea(game, names, "Turkey", "Armenia");
}

test "6.D.19. TEST CASE, EVEN WHEN SURVIVING IS IN ALTERNATIVE WAY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Russia", "Constantinople");
    try createFleetAt(names, &game, "Russia", "Black Sea");
    try createArmyAt(names, &game, "Russia", "Smyrna");
    try createFleetAt(names, &game, "Turkey", "Ankara");

    try issueSupportMove(names, &game, "Russia", "Constantinople", "Black Sea", "Ankara");
    try issueMove(names, &game, "Russia", "Black Sea", "Ankara");
    try issueSupportMove(names, &game, "Russia", "Smyrna", "Ankara", "Constantinople");
    try issueMove(names, &game, "Turkey", "Ankara", "Constantinople");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Turkey", "Ankara");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Constantinople");
    try expectUnitAtArea(game, names, "Russia", "Ankara");
}

test "6.D.20. TEST CASE, UNIT CANNOT CUT SUPPORT OF ITS OWN COUNTRY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createArmyAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "France", "English Channel");

    try issueSupportMove(names, &game, "England", "London", "North Sea", "English Channel");
    try issueMove(names, &game, "England", "North Sea", "English Channel");
    try issueMove(names, &game, "England", "Yorkshire", "London");
    try issueHold(names, &game, "France", "English Channel");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "France", "English Channel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "English Channel");
}

test "6.D.21. TEST CASE, DISLODGING DOES NOT CANCEL A SUPPORT CUT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createArmyAt(names, &game, "Italy", "Tyrolia");
    try createArmyAt(names, &game, "Germany", "Munich");
    try createArmyAt(names, &game, "Russia", "Silesia");
    try createArmyAt(names, &game, "Russia", "Berlin");

    try issueHold(names, &game, "Austria", "Trieste");
    try issueMove(names, &game, "Italy", "Venice", "Trieste");
    try issueSupportMove(names, &game, "Italy", "Tyrolia", "Venice", "Trieste");
    try issueMove(names, &game, "Germany", "Munich", "Tyrolia");
    try issueMove(names, &game, "Russia", "Silesia", "Munich");
    try issueSupportMove(names, &game, "Russia", "Berlin", "Silesia", "Munich");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Germany", "Munich");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Trieste");
    try expectUnitAtArea(game, names, "Russia", "Munich");
}

test "6.D.22. TEST CASE, IMPOSSIBLE FLEET MOVE CANNOT BE SUPPORTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.illegal_commands = .treat_as_hold;

    try createFleetAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Burgundy");
    try createArmyAt(names, &game, "Russia", "Munich");
    try createArmyAt(names, &game, "Russia", "Berlin");

    try issueMove(names, &game, "Germany", "Kiel", "Munich"); // Illegal
    try issueSupportMove(names, &game, "Germany", "Burgundy", "Kiel", "Munich"); // Illegal
    try issueMove(names, &game, "Russia", "Munich", "Kiel");
    try issueSupportMove(names, &game, "Russia", "Berlin", "Munich", "Kiel");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Germany", "Kiel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Kiel");
}

test "6.D.23. TEST CASE, IMPOSSIBLE COAST MOVE CANNOT BE SUPPORTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.illegal_commands = .treat_as_hold;

    try createFleetAt(names, &game, "Italy", "Gulf of Lyon");
    try createFleetAt(names, &game, "Italy", "Western Mediterranean Sea");
    try createFleetAt(names, &game, "France", "Spain North Coast");
    try createFleetAt(names, &game, "France", "Marseilles");

    try issueMove(names, &game, "Italy", "Gulf of Lyon", "Spain South Coast");
    try issueSupportMove(names, &game, "Italy", "Western Mediterranean Sea", "Gulf of Lyon", "Spain South Coast");
    try issueMove(names, &game, "France", "Spain North Coast", "Gulf of Lyon"); // Illegal
    try issueSupportMove(names, &game, "France", "Marseilles", "Spain North Coast", "Gulf of Lyon"); // Illegal

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "France", "Spain");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtProvince(game, names, "Italy", "Spain South Coast");
}

test "6.D.24. TEST CASE, IMPOSSIBLE ARMY MOVE CANNOT BE SUPPORTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.illegal_commands = .treat_as_hold;

    try createArmyAt(names, &game, "France", "Marseilles");
    try createFleetAt(names, &game, "France", "Spain South Coast");
    try createFleetAt(names, &game, "Italy", "Gulf of Lyon");
    try createFleetAt(names, &game, "Turkey", "Tyrrhenian Sea");
    try createFleetAt(names, &game, "Turkey", "Western Mediterranean Sea");

    try issueMove(names, &game, "France", "Marseilles", "Gulf of Lyon"); // Illegal
    try issueSupportMove(names, &game, "France", "Spain South Coast", "Marseilles", "Gulf of Lyon"); // Illegal
    try issueHold(names, &game, "Italy", "Gulf of Lyon");
    try issueSupportMove(names, &game, "Turkey", "Tyrrhenian Sea", "Western Mediterranean Sea", "Gulf of Lyon");
    try issueMove(names, &game, "Turkey", "Western Mediterranean Sea", "Gulf of Lyon");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Italy", "Gulf of Lyon");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Turkey", "Gulf of Lyon");
}

test "6.D.25. TEST CASE, FAILING HOLD SUPPORT CAN BE SUPPORTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createFleetAt(names, &game, "Russia", "Baltic Sea");
    try createArmyAt(names, &game, "Russia", "Prussia");

    try issueSupportHold(names, &game, "Germany", "Berlin", "Prussia");
    try issueSupportHold(names, &game, "Germany", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "Russia", "Baltic Sea", "Prussia", "Berlin");
    try issueMove(names, &game, "Russia", "Prussia", "Berlin");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Berlin");
    try expectUnitAtArea(game, names, "Russia", "Prussia");
}

test "6.D.26. TEST CASE, FAILING MOVE SUPPORT CAN BE SUPPORTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createFleetAt(names, &game, "Russia", "Baltic Sea");
    try createArmyAt(names, &game, "Russia", "Prussia");

    try issueSupportMove(names, &game, "Germany", "Berlin", "Prussia", "Silesia");
    try issueSupportHold(names, &game, "Germany", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "Russia", "Baltic Sea", "Prussia", "Berlin");
    try issueMove(names, &game, "Russia", "Prussia", "Berlin");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Berlin");
    try expectUnitAtArea(game, names, "Russia", "Prussia");
}

test "6.D.27. TEST CASE, FAILING CONVOY CAN BE SUPPORTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "Sweden");
    try createFleetAt(names, &game, "England", "Denmark");
    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Russia", "Baltic Sea");
    try createFleetAt(names, &game, "Russia", "Prussia");

    try issueMove(names, &game, "England", "Sweden", "Baltic Sea");
    try issueSupportMove(names, &game, "England", "Denmark", "Sweden", "Baltic Sea");
    try issueHold(names, &game, "Germany", "Berlin");
    try issueConvoyTransport(names, &game, "Russia", "Baltic Sea", "Berlin", "Livonia");
    try issueSupportHold(names, &game, "Russia", "Prussia", "Baltic Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Baltic Sea");
    try expectUnitAtArea(game, names, "England", "Sweden");
}

test "6.D.28. TEST CASE, IMPOSSIBLE MOVE AND SUPPORT" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createArmyAt(names, &game, "Austria", "Budapest");
        try createFleetAt(names, &game, "Russia", "Rumania");
        try createFleetAt(names, &game, "Turkey", "Black Sea");
        try createArmyAt(names, &game, "Turkey", "Bulgaria");

        try issueSupportHold(names, &game, "Austria", "Budapest", "Rumania");
        try issueMove(names, &game, "Russia", "Rumania", "Holland"); // Illegal
        try issueMove(names, &game, "Turkey", "Black Sea", "Rumania");
        try issueSupportMove(names, &game, "Turkey", "Bulgaria", "Black Sea", "Rumania");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Russia", "Rumania");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_stationary_as_hold;

        try createArmyAt(names, &game, "Austria", "Budapest");
        try createFleetAt(names, &game, "Russia", "Rumania");
        try createFleetAt(names, &game, "Turkey", "Black Sea");
        try createArmyAt(names, &game, "Turkey", "Bulgaria");

        try issueSupportHold(names, &game, "Austria", "Budapest", "Rumania");
        try issueMove(names, &game, "Russia", "Rumania", "Holland"); // Illegal
        try issueMove(names, &game, "Turkey", "Black Sea", "Rumania");
        try issueSupportMove(names, &game, "Turkey", "Bulgaria", "Black Sea", "Rumania");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "Russia", "Rumania");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Turkey", "Rumania");
    }
}

test "6.D.29. TEST CASE, MOVE TO IMPOSSIBLE COAST AND SUPPORT" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .adapt;
        game.options.illegal_commands = .treat_as_hold;

        try createArmyAt(names, &game, "Austria", "Budapest");
        try createFleetAt(names, &game, "Russia", "Rumania");
        try createFleetAt(names, &game, "Turkey", "Black Sea");
        try createArmyAt(names, &game, "Turkey", "Bulgaria");

        try issueSupportHold(names, &game, "Austria", "Budapest", "Rumania");
        try issueMove(names, &game, "Russia", "Rumania", "Bulgaria South Coast"); // Illegal
        try issueMove(names, &game, "Turkey", "Black Sea", "Rumania");
        try issueSupportMove(names, &game, "Turkey", "Bulgaria", "Black Sea", "Rumania");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Russia", "Rumania");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.adapt_area = .adapt;
        game.options.illegal_commands = .treat_stationary_as_hold;

        try createArmyAt(names, &game, "Austria", "Budapest");
        try createFleetAt(names, &game, "Russia", "Rumania");
        try createFleetAt(names, &game, "Turkey", "Black Sea");
        try createArmyAt(names, &game, "Turkey", "Bulgaria");

        try issueSupportHold(names, &game, "Austria", "Budapest", "Rumania");
        try issueMove(names, &game, "Russia", "Rumania", "Bulgaria South Coast"); // Illegal
        try issueMove(names, &game, "Turkey", "Black Sea", "Rumania");
        try issueSupportMove(names, &game, "Turkey", "Bulgaria", "Black Sea", "Rumania");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "Russia", "Rumania");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Turkey", "Rumania");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;
        game.options.adapt_area = .adapt_across_coasts;

        try createArmyAt(names, &game, "Austria", "Budapest");
        try createFleetAt(names, &game, "Russia", "Rumania");
        try createFleetAt(names, &game, "Turkey", "Black Sea");
        try createArmyAt(names, &game, "Turkey", "Bulgaria");

        try issueSupportHold(names, &game, "Austria", "Budapest", "Rumania");
        try issueMove(names, &game, "Russia", "Rumania", "Bulgaria South Coast"); // Converted
        try issueMove(names, &game, "Turkey", "Black Sea", "Rumania");
        try issueSupportMove(names, &game, "Turkey", "Bulgaria", "Black Sea", "Rumania");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "Russia", "Rumania");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Turkey", "Rumania");
    }
}

test "6.D.30. TEST CASE, MOVE WITHOUT COAST AND SUPPORT" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "Italy", "Aegean Sea");
        try createFleetAt(names, &game, "Russia", "Constantinople");
        try createFleetAt(names, &game, "Turkey", "Black Sea");
        try createArmyAt(names, &game, "Turkey", "Bulgaria");

        try issueSupportHold(names, &game, "Italy", "Aegean Sea", "Constantinople");
        try issueMove(names, &game, "Russia", "Constantinople", "Bulgaria"); // Illegal
        try issueMove(names, &game, "Turkey", "Black Sea", "Constantinople");
        try issueSupportMove(names, &game, "Turkey", "Bulgaria", "Black Sea", "Constantinople");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Russia", "Constantinople");
        try expectUnitAtArea(game, names, "Turkey", "Black Sea");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_stationary_as_hold;

        try createFleetAt(names, &game, "Italy", "Aegean Sea");
        try createFleetAt(names, &game, "Russia", "Constantinople");
        try createFleetAt(names, &game, "Turkey", "Black Sea");
        try createArmyAt(names, &game, "Turkey", "Bulgaria");

        try issueSupportHold(names, &game, "Italy", "Aegean Sea", "Constantinople");
        try issueMove(names, &game, "Russia", "Constantinople", "Bulgaria"); // Illegal
        try issueMove(names, &game, "Turkey", "Black Sea", "Constantinople");
        try issueSupportMove(names, &game, "Turkey", "Bulgaria", "Black Sea", "Constantinople");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "Russia", "Constantinople");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Turkey", "Constantinople");
    }
}

test "6.D.31. TEST CASE, A TRICKY IMPOSSIBLE SUPPORT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Austria", "Rumania");
    try createFleetAt(names, &game, "Turkey", "Black Sea");

    try issueConvoyMove(names, &game, "Austria", "Rumania", "Armenia");
    try std.testing.expectError(error.SupportNoPath, issueSupportMove(names, &game, "Turkey", "Black Sea", "Rumania", "Armenia"));
}

test "6.D.32. TEST CASE, A MISSING FLEET" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "England", "Edinburgh");
        try createArmyAt(names, &game, "England", "Liverpool");
        try createFleetAt(names, &game, "France", "London");
        try createArmyAt(names, &game, "Germany", "Yorkshire");

        try issueSupportMove(names, &game, "England", "Edinburgh", "Liverpool", "Yorkshire");
        try issueMove(names, &game, "England", "Liverpool", "Yorkshire");
        try issueSupportHold(names, &game, "France", "London", "Yorkshire");
        try std.testing.expectError(error.NoPath, issueConvoyMove(names, &game, "Germany", "Yorkshire", "Holland"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "England", "Edinburgh");
        try createArmyAt(names, &game, "England", "Liverpool");
        try createFleetAt(names, &game, "France", "London");
        try createArmyAt(names, &game, "Germany", "Yorkshire");

        try issueSupportMove(names, &game, "England", "Edinburgh", "Liverpool", "Yorkshire");
        try issueMove(names, &game, "England", "Liverpool", "Yorkshire");
        try issueSupportHold(names, &game, "France", "London", "Yorkshire");
        try issueConvoyMove(names, &game, "Germany", "Yorkshire", "Holland"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "Liverpool");
        try expectUnitAtArea(game, names, "Germany", "Yorkshire");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_stationary_as_hold;

        try createFleetAt(names, &game, "England", "Edinburgh");
        try createArmyAt(names, &game, "England", "Liverpool");
        try createFleetAt(names, &game, "France", "London");
        try createArmyAt(names, &game, "Germany", "Yorkshire");

        try issueSupportMove(names, &game, "England", "Edinburgh", "Liverpool", "Yorkshire");
        try issueMove(names, &game, "England", "Liverpool", "Yorkshire");
        try issueSupportHold(names, &game, "France", "London", "Yorkshire");
        try issueConvoyMove(names, &game, "Germany", "Yorkshire", "Holland"); // Illegal

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "Germany", "Yorkshire");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "Yorkshire");
    }
}

test "6.D.33. TEST CASE, UNWANTED SUPPORT ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Austria", "Serbia");
    try createArmyAt(names, &game, "Austria", "Vienna");
    try createArmyAt(names, &game, "Russia", "Galicia");
    try createArmyAt(names, &game, "Turkey", "Bulgaria");

    try issueMove(names, &game, "Austria", "Serbia", "Budapest");
    try issueMove(names, &game, "Austria", "Vienna", "Budapest");
    try issueSupportMove(names, &game, "Russia", "Galicia", "Serbia", "Budapest");
    try issueMove(names, &game, "Turkey", "Bulgaria", "Serbia");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Budapest");
    try expectUnitAtArea(game, names, "Austria", "Vienna");
    try expectUnitAtArea(game, names, "Turkey", "Serbia");
}

test "6.D.34. TEST CASE, SUPPORT TARGETING OWN AREA NOT ALLOWED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.illegal_commands = .treat_as_hold;

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createArmyAt(names, &game, "Germany", "Silesia");
    try createFleetAt(names, &game, "Germany", "Baltic Sea");
    try createArmyAt(names, &game, "Italy", "Prussia");
    try createArmyAt(names, &game, "Russia", "Warsaw");
    try createArmyAt(names, &game, "Russia", "Livonia");

    try issueMove(names, &game, "Germany", "Berlin", "Prussia");
    try issueSupportMove(names, &game, "Germany", "Silesia", "Berlin", "Prussia");
    try issueSupportMove(names, &game, "Germany", "Baltic Sea", "Berlin", "Prussia");
    try issueSupportMove(names, &game, "Italy", "Prussia", "Livonia", "Prussia"); // Illegal
    try issueSupportMove(names, &game, "Russia", "Warsaw", "Livonia", "Prussia");
    try issueMove(names, &game, "Russia", "Livonia", "Prussia");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Italy", "Prussia");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Prussia");
    try expectUnitAtArea(game, names, "Russia", "Livonia");
}

// 6.E. TEST CASES, HEAD-TO-HEAD BATTLES AND BELEAGUERED GARRISON

test "6.E.1. TEST CASE, DISLODGED UNIT HAS NO EFFECT ON ATTACKER'S AREA" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Silesia");
    try createArmyAt(names, &game, "Russia", "Prussia");

    try issueMove(names, &game, "Germany", "Berlin", "Prussia");
    try issueMove(names, &game, "Germany", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "Germany", "Silesia", "Berlin", "Prussia");
    try issueMove(names, &game, "Russia", "Prussia", "Berlin");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Russia", "Prussia");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Prussia");
    try expectUnitAtArea(game, names, "Germany", "Berlin");
}

test "6.E.2. TEST CASE, NO SELF DISLODGEMENT IN HEAD-TO-HEAD BATTLE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Munich");

    try issueMove(names, &game, "Germany", "Berlin", "Kiel");
    try issueMove(names, &game, "Germany", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "Germany", "Munich", "Berlin", "Kiel");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Berlin");
    try expectUnitAtArea(game, names, "Germany", "Kiel");
}

test "6.E.3. TEST CASE, NO HELP IN DISLODGING OWN UNIT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "England", "Kiel");
    try createArmyAt(names, &game, "Germany", "Munich");

    try issueMove(names, &game, "Germany", "Berlin", "Kiel");
    try issueSupportMove(names, &game, "Germany", "Munich", "Kiel", "Berlin");
    try issueMove(names, &game, "England", "Kiel", "Berlin");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Berlin");
    try expectUnitAtArea(game, names, "England", "Kiel");
    try expectUnitAtArea(game, names, "Germany", "Munich");
}

test "6.E.4. TEST CASE, NON-DISLODGED LOSER STILL HAS EFFECT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Germany", "Holland");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Germany", "Skagerrak");
    try createFleetAt(names, &game, "France", "North Sea");
    try createFleetAt(names, &game, "France", "Belgium");
    try createFleetAt(names, &game, "England", "Edinburgh");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "England", "Norwegian Sea");
    try createArmyAt(names, &game, "Austria", "Kiel");
    try createArmyAt(names, &game, "Austria", "Ruhr");

    try issueMove(names, &game, "Germany", "Holland", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Helgoland Bight", "Holland", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Skagerrak", "Holland", "North Sea");
    try issueMove(names, &game, "France", "North Sea", "Holland");
    try issueSupportMove(names, &game, "France", "Belgium", "North Sea", "Holland");
    try issueSupportMove(names, &game, "England", "Edinburgh", "Norwegian Sea", "North Sea");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Norwegian Sea", "North Sea");
    try issueMove(names, &game, "England", "Norwegian Sea", "North Sea");
    try issueSupportMove(names, &game, "Austria", "Kiel", "Ruhr", "Holland");
    try issueMove(names, &game, "Austria", "Ruhr", "Holland");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "North Sea");
    try expectUnitAtArea(game, names, "Germany", "Holland");
    try expectUnitAtArea(game, names, "Austria", "Ruhr");
    try expectUnitAtArea(game, names, "England", "Norwegian Sea");
}

test "6.E.5. TEST CASE, LOSER DISLODGED BY ANOTHER ARMY STILL HAS EFFECT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Germany", "Holland");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Germany", "Skagerrak");
    try createFleetAt(names, &game, "France", "North Sea");
    try createFleetAt(names, &game, "France", "Belgium");
    try createFleetAt(names, &game, "England", "Edinburgh");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "England", "Norwegian Sea");
    try createFleetAt(names, &game, "England", "London");

    try createArmyAt(names, &game, "Austria", "Kiel");
    try createArmyAt(names, &game, "Austria", "Ruhr");

    try issueMove(names, &game, "Germany", "Holland", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Helgoland Bight", "Holland", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Skagerrak", "Holland", "North Sea");
    try issueMove(names, &game, "France", "North Sea", "Holland");
    try issueSupportMove(names, &game, "France", "Belgium", "North Sea", "Holland");
    try issueSupportMove(names, &game, "England", "Edinburgh", "Norwegian Sea", "North Sea");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Norwegian Sea", "North Sea");
    try issueMove(names, &game, "England", "Norwegian Sea", "North Sea");
    try issueSupportMove(names, &game, "England", "London", "Norwegian Sea", "North Sea");
    try issueSupportMove(names, &game, "Austria", "Kiel", "Ruhr", "Holland");
    try issueMove(names, &game, "Austria", "Ruhr", "Holland");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "France", "North Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "North Sea");
    try expectUnitAtArea(game, names, "Germany", "Holland");
    try expectUnitAtArea(game, names, "Austria", "Ruhr");
}

test "6.E.6. TEST CASE, NOT DISLODGE BECAUSE OF OWN SUPPORT STILL HAS EFFECT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Germany", "Holland");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "France", "North Sea");
    try createFleetAt(names, &game, "France", "Belgium");
    try createFleetAt(names, &game, "France", "English Channel");
    try createArmyAt(names, &game, "Austria", "Kiel");
    try createArmyAt(names, &game, "Austria", "Ruhr");

    try issueMove(names, &game, "Germany", "Holland", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Helgoland Bight", "Holland", "North Sea");
    try issueMove(names, &game, "France", "North Sea", "Holland");
    try issueSupportMove(names, &game, "France", "Belgium", "North Sea", "Holland");
    try issueSupportMove(names, &game, "France", "English Channel", "Holland", "North Sea");
    try issueSupportMove(names, &game, "Austria", "Kiel", "Ruhr", "Holland");
    try issueMove(names, &game, "Austria", "Ruhr", "Holland");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "North Sea");
    try expectUnitAtArea(game, names, "Germany", "Holland");
    try expectUnitAtArea(game, names, "Austria", "Ruhr");
}

test "6.E.7. TEST CASE, NO SELF DISLODGEMENT WITH BELEAGUERED GARRISON" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "Germany", "Holland");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Russia", "Skagerrak");
    try createFleetAt(names, &game, "Russia", "Norway");

    try issueHold(names, &game, "England", "North Sea");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Norway", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Holland", "Helgoland Bight", "North Sea");
    try issueMove(names, &game, "Germany", "Helgoland Bight", "North Sea");
    try issueSupportMove(names, &game, "Russia", "Skagerrak", "Norway", "North Sea");
    try issueMove(names, &game, "Russia", "Norway", "North Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "North Sea");
    try expectUnitAtArea(game, names, "Germany", "Helgoland Bight");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.E.8. TEST CASE, NO SELF DISLODGEMENT WITH BELEAGUERED GARRISON AND HEAD-TO-HEAD BATTLE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "Germany", "Holland");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Russia", "Skagerrak");
    try createFleetAt(names, &game, "Russia", "Norway");

    try issueMove(names, &game, "England", "North Sea", "Norway");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Norway", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Holland", "Helgoland Bight", "North Sea");
    try issueMove(names, &game, "Germany", "Helgoland Bight", "North Sea");
    try issueSupportMove(names, &game, "Russia", "Skagerrak", "Norway", "North Sea");
    try issueMove(names, &game, "Russia", "Norway", "North Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "North Sea");
    try expectUnitAtArea(game, names, "Germany", "Helgoland Bight");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.E.9. TEST CASE, ALMOST SELF DISLODGEMENT WITH BELEAGUERED GARRISON" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "Germany", "Holland");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Russia", "Skagerrak");
    try createFleetAt(names, &game, "Russia", "Norway");

    try issueMove(names, &game, "England", "North Sea", "Norwegian Sea");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Norway", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Holland", "Helgoland Bight", "North Sea");
    try issueMove(names, &game, "Germany", "Helgoland Bight", "North Sea");
    try issueSupportMove(names, &game, "Russia", "Skagerrak", "Norway", "North Sea");
    try issueMove(names, &game, "Russia", "Norway", "North Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Norwegian Sea");
    try expectUnitAtArea(game, names, "Germany", "Helgoland Bight");
    try expectUnitAtArea(game, names, "Russia", "North Sea");
}

test "6.E.10. TEST CASE, ALMOST CIRCULAR MOVEMENT WITH NO SELF DISLODGEMENT WITH BELEAGUERED GARRISON" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "Germany", "Holland");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Germany", "Denmark");
    try createFleetAt(names, &game, "Russia", "Skagerrak");
    try createFleetAt(names, &game, "Russia", "Norway");

    try issueMove(names, &game, "England", "North Sea", "Denmark");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Norway", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Holland", "Helgoland Bight", "North Sea");
    try issueMove(names, &game, "Germany", "Helgoland Bight", "North Sea");
    try issueMove(names, &game, "Germany", "Denmark", "Helgoland Bight");
    try issueSupportMove(names, &game, "Russia", "Skagerrak", "Norway", "North Sea");
    try issueMove(names, &game, "Russia", "Norway", "North Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "North Sea");
    try expectUnitAtArea(game, names, "Germany", "Helgoland Bight");
    try expectUnitAtArea(game, names, "Germany", "Denmark");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.E.11. TEST CASE, NO SELF DISLODGEMENT WITH BELEAGUERED GARRISON, UNIT SWAP WITH ADJACENT CONVOYING AND TWO COASTS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "France", "Spain");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
    try createFleetAt(names, &game, "France", "Gulf of Lyon");
    try createArmyAt(names, &game, "Germany", "Marseilles");
    try createArmyAt(names, &game, "Germany", "Gascony");
    try createFleetAt(names, &game, "Italy", "Portugal");
    try createFleetAt(names, &game, "Italy", "Western Mediterranean Sea");

    try issueConvoyMove(names, &game, "France", "Spain", "Portugal");
    try issueConvoyTransport(names, &game, "France", "Mid-Atlantic Ocean", "Spain", "Portugal");
    try issueSupportMove(names, &game, "France", "Gulf of Lyon", "Portugal", "Spain North Coast");
    try issueSupportMove(names, &game, "Germany", "Marseilles", "Gascony", "Spain");
    try issueMove(names, &game, "Germany", "Gascony", "Spain");
    try issueMove(names, &game, "Italy", "Portugal", "Spain North Coast");
    try issueSupportMove(names, &game, "Italy", "Western Mediterranean Sea", "Portugal", "Spain North Coast");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "Portugal");
    try expectUnitAtArea(game, names, "Germany", "Gascony");
    try expectUnitAtProvince(game, names, "Italy", "Spain North Coast");
}

test "6.E.12. TEST CASE, SUPPORT ON ATTACK ON OWN UNIT CAN BE USED FOR OTHER MEANS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Austria", "Budapest");
    try createArmyAt(names, &game, "Austria", "Serbia");
    try createArmyAt(names, &game, "Italy", "Vienna");
    try createArmyAt(names, &game, "Russia", "Galicia");
    try createArmyAt(names, &game, "Russia", "Rumania");

    try issueMove(names, &game, "Austria", "Budapest", "Rumania");
    try issueSupportMove(names, &game, "Austria", "Serbia", "Vienna", "Budapest");
    try issueMove(names, &game, "Italy", "Vienna", "Budapest");
    try issueMove(names, &game, "Russia", "Galicia", "Budapest");
    try issueSupportMove(names, &game, "Russia", "Rumania", "Galicia", "Budapest");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Austria", "Budapest");
    try expectUnitAtArea(game, names, "Italy", "Vienna");
    try expectUnitAtArea(game, names, "Russia", "Galicia");
}

test "6.E.13. TEST CASE, THREE WAY BELEAGUERED GARRISON" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "Edinburgh");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "France", "Belgium");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "Germany", "North Sea");
    try createFleetAt(names, &game, "Russia", "Norwegian Sea");
    try createFleetAt(names, &game, "Russia", "Norway");

    try issueSupportMove(names, &game, "England", "Edinburgh", "Yorkshire", "North Sea");
    try issueMove(names, &game, "England", "Yorkshire", "North Sea");
    try issueMove(names, &game, "France", "Belgium", "North Sea");
    try issueSupportMove(names, &game, "France", "English Channel", "Belgium", "North Sea");
    try issueMove(names, &game, "Russia", "Norwegian Sea", "North Sea");
    try issueSupportMove(names, &game, "Russia", "Norway", "Norwegian Sea", "North Sea");
    try issueHold(names, &game, "Germany", "North Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "North Sea");
    try expectUnitAtArea(game, names, "England", "Yorkshire");
    try expectUnitAtArea(game, names, "France", "Belgium");
    try expectUnitAtArea(game, names, "Russia", "Norwegian Sea");
}

test "6.E.14. TEST CASE, ILLEGAL HEAD-TO-HEAD BATTLE CAN STILL DEFEND" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.illegal_commands = .treat_as_hold;

    try createArmyAt(names, &game, "England", "Liverpool");
    try createFleetAt(names, &game, "Russia", "Edinburgh");

    try issueMove(names, &game, "England", "Liverpool", "Edinburgh");
    try issueMove(names, &game, "Russia", "Edinburgh", "Liverpool"); // Illegal

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Liverpool");
    try expectUnitAtArea(game, names, "Russia", "Edinburgh");
}

test "6.E.15. TEST CASE, THE FRIENDLY HEAD-TO-HEAD BATTLE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "Holland");
    try createArmyAt(names, &game, "England", "Ruhr");
    try createArmyAt(names, &game, "France", "Kiel");
    try createArmyAt(names, &game, "France", "Munich");
    try createArmyAt(names, &game, "France", "Silesia");
    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Denmark");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Russia", "Baltic Sea");
    try createArmyAt(names, &game, "Russia", "Prussia");

    try issueSupportMove(names, &game, "England", "Holland", "Ruhr", "Kiel");
    try issueMove(names, &game, "England", "Ruhr", "Kiel");
    try issueMove(names, &game, "France", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "France", "Munich", "Kiel", "Berlin");
    try issueSupportMove(names, &game, "France", "Silesia", "Kiel", "Berlin");
    try issueMove(names, &game, "Germany", "Berlin", "Kiel");
    try issueSupportMove(names, &game, "Germany", "Denmark", "Berlin", "Kiel");
    try issueSupportMove(names, &game, "Germany", "Helgoland Bight", "Berlin", "Kiel");
    try issueSupportMove(names, &game, "Russia", "Baltic Sea", "Prussia", "Berlin");
    try issueMove(names, &game, "Russia", "Prussia", "Berlin");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Ruhr");
    try expectUnitAtArea(game, names, "France", "Kiel");
    try expectUnitAtArea(game, names, "Germany", "Berlin");
    try expectUnitAtArea(game, names, "Russia", "Prussia");
}

// 6.F. TEST CASES, CONVOYS

test "6.F.1. TEST CASE, NO CONVOY IN COASTAL AREAS" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .throw_error;

        try createArmyAt(names, &game, "Turkey", "Greece");
        try createFleetAt(names, &game, "Turkey", "Aegean Sea");
        try createFleetAt(names, &game, "Turkey", "Constantinople");
        try createFleetAt(names, &game, "Turkey", "Black Sea");

        try std.testing.expectError(error.NoPath, issueConvoyMove(names, &game, "Turkey", "Greece", "Sevastopol"));
        try std.testing.expectError(error.TransportNoPath, issueConvoyTransport(names, &game, "Turkey", "Aegean Sea", "Greece", "Sevastopol"));
        try std.testing.expectError(error.WrongType, issueConvoyTransport(names, &game, "Turkey", "Constantinople", "Greece", "Sevastopol"));
        try std.testing.expectError(error.TransportNoPath, issueConvoyTransport(names, &game, "Turkey", "Black Sea", "Greece", "Sevastopol"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_commands = .treat_as_hold;

        try createArmyAt(names, &game, "Turkey", "Greece");
        try createFleetAt(names, &game, "Turkey", "Aegean Sea");
        try createFleetAt(names, &game, "Turkey", "Constantinople");
        try createFleetAt(names, &game, "Turkey", "Black Sea");

        try issueConvoyMove(names, &game, "Turkey", "Greece", "Sevastopol");
        try issueConvoyTransport(names, &game, "Turkey", "Aegean Sea", "Greece", "Sevastopol");
        try issueConvoyTransport(names, &game, "Turkey", "Constantinople", "Greece", "Sevastopol"); // Illegal
        try issueConvoyTransport(names, &game, "Turkey", "Black Sea", "Greece", "Sevastopol");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Turkey", "Greece");
    }
}

test "6.F.2. TEST CASE, AN ARMY BEING CONVOYED CAN BOUNCE AS NORMAL" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "English Channel");
    try createArmyAt(names, &game, "France", "Paris");

    try issueConvoyMove(names, &game, "England", "London", "Brest");
    try issueConvoyTransport(names, &game, "England", "English Channel", "London", "Brest");
    try issueMove(names, &game, "France", "Paris", "Brest");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "London");
    try expectUnitAtArea(game, names, "France", "Paris");
}

test "6.F.3. TEST CASE, AN ARMY BEING CONVOYED CAN RECEIVE SUPPORT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "English Channel");
    try createFleetAt(names, &game, "England", "Mid-Atlantic Ocean");
    try createArmyAt(names, &game, "France", "Paris");

    try issueConvoyMove(names, &game, "England", "London", "Brest");
    try issueConvoyTransport(names, &game, "England", "English Channel", "London", "Brest");
    try issueSupportMove(names, &game, "England", "Mid-Atlantic Ocean", "London", "Brest");
    try issueMove(names, &game, "France", "Paris", "Brest");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Brest");
    try expectUnitAtArea(game, names, "France", "Paris");
}

test "6.F.4. TEST CASE, AN ATTACKED CONVOY IS NOT DISRUPTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "Germany", "Skagerrak");

    try issueConvoyMove(names, &game, "England", "London", "Holland");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Holland");
    try issueMove(names, &game, "Germany", "Skagerrak", "North Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Holland");
}

test "6.F.5. TEST CASE, A BELEAGUERED CONVOY IS NOT DISRUPTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "France", "Belgium");
    try createFleetAt(names, &game, "Germany", "Skagerrak");
    try createFleetAt(names, &game, "Germany", "Denmark");

    try issueConvoyMove(names, &game, "England", "London", "Holland");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Holland");
    try issueMove(names, &game, "France", "English Channel", "North Sea");
    try issueSupportMove(names, &game, "France", "Belgium", "English Channel", "North Sea");
    try issueMove(names, &game, "Germany", "Skagerrak", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Denmark", "Skagerrak", "North Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Holland");
}

test "6.F.6. TEST CASE, DISLODGED CONVOY DOES NOT CUT SUPPORT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createArmyAt(names, &game, "Germany", "Holland");
    try createArmyAt(names, &game, "Germany", "Belgium");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Germany", "Skagerrak");
    try createArmyAt(names, &game, "France", "Picardy");
    try createArmyAt(names, &game, "France", "Burgundy");

    try issueConvoyMove(names, &game, "England", "London", "Holland");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Holland");
    try issueSupportHold(names, &game, "Germany", "Holland", "Belgium");
    try issueSupportHold(names, &game, "Germany", "Belgium", "Holland");
    try issueSupportMove(names, &game, "Germany", "Helgoland Bight", "Skagerrak", "North Sea");
    try issueMove(names, &game, "Germany", "Skagerrak", "North Sea");
    try issueMove(names, &game, "France", "Picardy", "Belgium");
    try issueSupportMove(names, &game, "France", "Burgundy", "Picardy", "Belgium");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "North Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "London");
    try expectUnitAtArea(game, names, "France", "Picardy");
}

test "6.F.7. TEST CASE, DISLODGED CONVOY DOES NOT CAUSE CONTESTED AREA" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Germany", "Skagerrak");

    try issueConvoyMove(names, &game, "England", "London", "Holland");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Holland");
    try issueSupportMove(names, &game, "Germany", "Helgoland Bight", "Skagerrak", "North Sea");
    try issueMove(names, &game, "Germany", "Skagerrak", "North Sea");

    try game.adjudicateSpring();

    try issueRetreat(names, &game, "England", "North Sea", "Holland");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Holland");
}

test "6.F.8. TEST CASE, DISLODGED CONVOY DOES NOT CAUSE A BOUNCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Germany", "Skagerrak");
    try createArmyAt(names, &game, "Germany", "Belgium");

    try issueConvoyMove(names, &game, "England", "London", "Holland");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Holland");
    try issueSupportMove(names, &game, "Germany", "Helgoland Bight", "Skagerrak", "North Sea");
    try issueMove(names, &game, "Germany", "Skagerrak", "North Sea");
    try issueMove(names, &game, "Germany", "Belgium", "Holland");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "North Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Holland");
    try expectUnitAtArea(game, names, "England", "London");
}

test "6.F.9. TEST CASE, DISLODGE OF MULTI-ROUTE CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "English Channel");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");

    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueConvoyTransport(names, &game, "England", "English Channel", "London", "Belgium");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium");
    try issueSupportMove(names, &game, "France", "Brest", "Mid-Atlantic Ocean", "English Channel");
    try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "English Channel");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "English Channel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Belgium");
}

test "6.F.10. TEST CASE, DISLODGE OF MULTI-ROUTE CONVOY WITH FOREIGN FLEET" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "Germany", "English Channel");
    try createFleetAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");

    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium");
    try issueConvoyTransport(names, &game, "Germany", "English Channel", "London", "Belgium");
    try issueSupportMove(names, &game, "France", "Brest", "Mid-Atlantic Ocean", "English Channel");
    try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "English Channel");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Germany", "English Channel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Belgium");
}

test "6.F.11. TEST CASE, DISLODGE OF MULTI-ROUTE CONVOY WITH ONLY FOREIGN FLEETS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "Germany", "English Channel");
    try createFleetAt(names, &game, "Russia", "North Sea");
    try createFleetAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");

    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueConvoyTransport(names, &game, "Germany", "English Channel", "London", "Belgium");
    try issueConvoyTransport(names, &game, "Russia", "North Sea", "London", "Belgium");
    try issueSupportMove(names, &game, "France", "Brest", "Mid-Atlantic Ocean", "English Channel");
    try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "English Channel");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Germany", "English Channel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Belgium");
}

test "6.F.12. TEST CASE, DISLODGED CONVOYING FLEET NOT ON ROUTE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.illegal_commands = .treat_as_hold;

    try createFleetAt(names, &game, "England", "English Channel");
    try createFleetAt(names, &game, "England", "Irish Sea");
    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "France", "North Atlantic Ocean");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");

    try issueConvoyTransport(names, &game, "England", "English Channel", "London", "Belgium");
    try issueConvoyTransport(names, &game, "England", "Irish Sea", "London", "Belgium"); // Illegal
    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueSupportMove(names, &game, "France", "North Atlantic Ocean", "Mid-Atlantic Ocean", "Irish Sea");
    try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "Irish Sea");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "Irish Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Belgium");
}

test "6.F.13. TEST CASE, THE UNWANTED ALTERNATIVE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "Germany", "Holland");
    try createFleetAt(names, &game, "Germany", "Denmark");

    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium");
    try issueConvoyTransport(names, &game, "France", "English Channel", "London", "Belgium");
    try issueMove(names, &game, "Germany", "Denmark", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Holland", "Denmark", "North Sea");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "North Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Belgium");
}

test "6.F.14. TEST CASE, SIMPLE CONVOY PARADOX" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "Wales");
    try createArmyAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "English Channel");

    try issueSupportMove(names, &game, "England", "London", "Wales", "English Channel");
    try issueMove(names, &game, "England", "Wales", "English Channel");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Brest", "London");
    try issueConvoyMove(names, &game, "France", "Brest", "London");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "France", "English Channel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "English Channel");
    try expectUnitAtArea(game, names, "France", "Brest");
}

test "6.F.15. TEST CASE, SIMPLE CONVOY PARADOX WITH ADDITIONAL CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "Wales");
    try createArmyAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "Italy", "Irish Sea");
    try createFleetAt(names, &game, "Italy", "Mid-Atlantic Ocean");
    try createArmyAt(names, &game, "Italy", "North Africa");

    try issueSupportMove(names, &game, "England", "London", "Wales", "English Channel");
    try issueMove(names, &game, "England", "Wales", "English Channel");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Brest", "London");
    try issueConvoyMove(names, &game, "France", "Brest", "London");
    try issueConvoyTransport(names, &game, "Italy", "Irish Sea", "North Africa", "Wales");
    try issueConvoyTransport(names, &game, "Italy", "Mid-Atlantic Ocean", "North Africa", "Wales");
    try issueConvoyMove(names, &game, "Italy", "North Africa", "Wales");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "France", "English Channel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "English Channel");
    try expectUnitAtArea(game, names, "France", "Brest");
    try expectUnitAtArea(game, names, "Italy", "Wales");
}

test "6.F.16. TEST CASE, PANDIN'S PARADOX" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "Wales");
    try createArmyAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "Germany", "North Sea");
    try createFleetAt(names, &game, "Germany", "Belgium");

    try issueSupportMove(names, &game, "England", "London", "Wales", "English Channel");
    try issueMove(names, &game, "England", "Wales", "English Channel");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Brest", "London");
    try issueConvoyMove(names, &game, "France", "Brest", "London");
    try issueSupportMove(names, &game, "Germany", "North Sea", "Belgium", "English Channel");
    try issueMove(names, &game, "Germany", "Belgium", "English Channel");

    try game.adjudicateSpring();

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Wales");
    try expectUnitAtArea(game, names, "France", "Brest");
    try expectUnitAtArea(game, names, "Germany", "Belgium");
}

test "6.F.17. TEST CASE, PANDIN'S EXTENDED PARADOX" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "Wales");
    try createArmyAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "France", "Yorkshire");
    try createFleetAt(names, &game, "Germany", "North Sea");
    try createFleetAt(names, &game, "Germany", "Belgium");

    try issueSupportMove(names, &game, "England", "London", "Wales", "English Channel");
    try issueMove(names, &game, "England", "Wales", "English Channel");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Brest", "London");
    try issueConvoyMove(names, &game, "France", "Brest", "London");
    try issueSupportMove(names, &game, "France", "Yorkshire", "Brest", "London");
    try issueSupportMove(names, &game, "Germany", "North Sea", "Belgium", "English Channel");
    try issueMove(names, &game, "Germany", "Belgium", "English Channel");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "English Channel");
    try expectUnitAtArea(game, names, "England", "Wales");
    try expectUnitAtArea(game, names, "France", "Brest");
    try expectUnitAtArea(game, names, "Germany", "Belgium");
}

test "6.F.18. TEST CASE, BETRAYAL PARADOX" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "North Sea");
    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "English Channel");
    try createFleetAt(names, &game, "France", "Belgium");
    try createFleetAt(names, &game, "Germany", "Helgoland Bight");
    try createFleetAt(names, &game, "Germany", "Skagerrak");

    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium");
    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueSupportMove(names, &game, "England", "English Channel", "London", "Belgium");
    try issueSupportHold(names, &game, "France", "Belgium", "North Sea");
    try issueSupportMove(names, &game, "Germany", "Helgoland Bight", "Skagerrak", "North Sea");
    try issueMove(names, &game, "Germany", "Skagerrak", "North Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "London");
    try expectUnitAtArea(game, names, "Germany", "Skagerrak");
}

test "6.F.19. TEST CASE, MULTI-ROUTE CONVOY DISRUPTION PARADOX" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "France", "Tunis");
    try createFleetAt(names, &game, "France", "Tyrrhenian Sea");
    try createFleetAt(names, &game, "France", "Ionian Sea");
    try createFleetAt(names, &game, "Italy", "Naples");
    try createFleetAt(names, &game, "Italy", "Rome");

    try issueConvoyMove(names, &game, "France", "Tunis", "Naples");
    try issueConvoyTransport(names, &game, "France", "Tyrrhenian Sea", "Tunis", "Naples");
    try issueConvoyTransport(names, &game, "France", "Ionian Sea", "Tunis", "Naples");
    try issueMove(names, &game, "Italy", "Rome", "Tyrrhenian Sea");
    try issueSupportMove(names, &game, "Italy", "Naples", "Rome", "Tyrrhenian Sea");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "Tunis");
    try expectUnitAtArea(game, names, "Italy", "Rome");
}

test "6.F.20. TEST CASE, UNWANTED MULTI-ROUTE CONVOY PARADOX" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "France", "Tunis");
    try createFleetAt(names, &game, "France", "Tyrrhenian Sea");
    try createFleetAt(names, &game, "Italy", "Naples");
    try createFleetAt(names, &game, "Italy", "Ionian Sea");
    try createFleetAt(names, &game, "Turkey", "Aegean Sea");
    try createFleetAt(names, &game, "Turkey", "Eastern Mediterranean Sea");

    try issueConvoyMove(names, &game, "France", "Tunis", "Naples");
    try issueConvoyTransport(names, &game, "France", "Tyrrhenian Sea", "Tunis", "Naples");
    try issueConvoyTransport(names, &game, "Italy", "Ionian Sea", "Tunis", "Naples");
    try issueSupportHold(names, &game, "Italy", "Naples", "Ionian Sea");
    try issueMove(names, &game, "Turkey", "Eastern Mediterranean Sea", "Ionian Sea");
    try issueSupportMove(names, &game, "Turkey", "Aegean Sea", "Eastern Mediterranean Sea", "Ionian Sea");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Italy", "Ionian Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "Tunis");
    try expectUnitAtArea(game, names, "Turkey", "Ionian Sea");
}

test "6.F.21. TEST CASE, DAD'S ARMY CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Russia", "Edinburgh");
    try createFleetAt(names, &game, "Russia", "Norwegian Sea");
    try createArmyAt(names, &game, "Russia", "Norway");
    try createFleetAt(names, &game, "France", "Irish Sea");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
    try createArmyAt(names, &game, "England", "Liverpool");
    try createFleetAt(names, &game, "England", "North Atlantic Ocean");
    try createFleetAt(names, &game, "England", "Clyde");

    try issueSupportMove(names, &game, "Russia", "Edinburgh", "Norway", "Clyde");
    try issueConvoyTransport(names, &game, "Russia", "Norwegian Sea", "Norway", "Clyde");
    try issueConvoyMove(names, &game, "Russia", "Norway", "Clyde");
    try issueConvoyTransport(names, &game, "England", "North Atlantic Ocean", "Liverpool", "Clyde");
    try issueConvoyMove(names, &game, "England", "Liverpool", "Clyde");
    try issueSupportHold(names, &game, "England", "Clyde", "North Atlantic Ocean");
    try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "North Atlantic Ocean");
    try issueSupportMove(names, &game, "France", "Irish Sea", "Mid-Atlantic Ocean", "North Atlantic Ocean");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "North Atlantic Ocean");
    try issueRetreatDisband(names, &game, "England", "Clyde");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Russia", "Clyde");
    try expectUnitAtArea(game, names, "France", "North Atlantic Ocean");
}

test "6.F.22. TEST CASE, SECOND ORDER PARADOX WITH TWO RESOLUTIONS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "Edinburgh");
    try createFleetAt(names, &game, "England", "London");
    try createArmyAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "Germany", "Belgium");
    try createFleetAt(names, &game, "Germany", "Picardy");
    try createArmyAt(names, &game, "Russia", "Norway");
    try createFleetAt(names, &game, "Russia", "North Sea");

    try issueMove(names, &game, "England", "Edinburgh", "North Sea");
    try issueSupportMove(names, &game, "England", "London", "Edinburgh", "North Sea");
    try issueConvoyMove(names, &game, "France", "Brest", "London");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Brest", "London");
    try issueSupportMove(names, &game, "Germany", "Belgium", "Picardy", "English Channel");
    try issueMove(names, &game, "Germany", "Picardy", "English Channel");
    try issueConvoyTransport(names, &game, "Russia", "North Sea", "Norway", "Belgium");
    try issueConvoyMove(names, &game, "Russia", "Norway", "Belgium");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "France", "English Channel");
    try issueRetreatDisband(names, &game, "Russia", "North Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "North Sea");
    try expectUnitAtArea(game, names, "France", "Brest");
    try expectUnitAtArea(game, names, "Germany", "English Channel");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.F.23. TEST CASE, SECOND ORDER PARADOX WITH TWO EXCLUSIVE CONVOYS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "Edinburgh");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createArmyAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "Germany", "Belgium");
    try createFleetAt(names, &game, "Germany", "London");
    try createFleetAt(names, &game, "Italy", "Mid-Atlantic Ocean");
    try createFleetAt(names, &game, "Italy", "Irish Sea");
    try createArmyAt(names, &game, "Russia", "Norway");
    try createFleetAt(names, &game, "Russia", "North Sea");

    try issueMove(names, &game, "England", "Edinburgh", "North Sea");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Edinburgh", "North Sea");
    try issueConvoyMove(names, &game, "France", "Brest", "London");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Brest", "London");
    try issueSupportHold(names, &game, "Germany", "Belgium", "English Channel");
    try issueSupportHold(names, &game, "Germany", "London", "North Sea");
    try issueMove(names, &game, "Italy", "Mid-Atlantic Ocean", "English Channel");
    try issueSupportMove(names, &game, "Italy", "Irish Sea", "Mid-Atlantic Ocean", "English Channel");
    try issueConvoyTransport(names, &game, "Russia", "North Sea", "Norway", "Belgium");
    try issueConvoyMove(names, &game, "Russia", "Norway", "Belgium");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Edinburgh");
    try expectUnitAtArea(game, names, "France", "Brest");
    try expectUnitAtArea(game, names, "Italy", "Mid-Atlantic Ocean");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.F.24. TEST CASE, SECOND ORDER PARADOX WITH NO RESOLUTION" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "Edinburgh");
    try createFleetAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "England", "Irish Sea");
    try createFleetAt(names, &game, "England", "Mid-Atlantic Ocean");
    try createArmyAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "English Channel");
    try createFleetAt(names, &game, "France", "Belgium");
    try createArmyAt(names, &game, "Russia", "Norway");
    try createFleetAt(names, &game, "Russia", "North Sea");

    try issueMove(names, &game, "England", "Edinburgh", "North Sea");
    try issueSupportMove(names, &game, "England", "London", "Edinburgh", "North Sea");
    try issueMove(names, &game, "England", "Irish Sea", "English Channel");
    try issueSupportMove(names, &game, "England", "Mid-Atlantic Ocean", "Irish Sea", "English Channel");
    try issueConvoyMove(names, &game, "France", "Brest", "London");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Brest", "London");
    try issueSupportHold(names, &game, "France", "Belgium", "English Channel");
    try issueConvoyMove(names, &game, "Russia", "Norway", "Belgium");
    try issueConvoyTransport(names, &game, "Russia", "North Sea", "Norway", "Belgium");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Russia", "North Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "North Sea");
    try expectUnitAtArea(game, names, "England", "Irish Sea");
    try expectUnitAtArea(game, names, "France", "Brest");
    try expectUnitAtArea(game, names, "France", "English Channel");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.F.25. TEST CASE, CUT SUPPORT LAST" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Germany", "Ruhr");
    try createArmyAt(names, &game, "Germany", "Holland");
    try createArmyAt(names, &game, "Germany", "Denmark");
    try createFleetAt(names, &game, "Germany", "Skagerrak");
    try createArmyAt(names, &game, "Germany", "Finland");
    try createArmyAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "England", "Helgoland Bight");
    try createArmyAt(names, &game, "England", "Belgium");
    try createFleetAt(names, &game, "Russia", "Norwegian Sea");
    try createFleetAt(names, &game, "Russia", "Norway");
    try createFleetAt(names, &game, "Russia", "Sweden");

    try issueMove(names, &game, "Germany", "Ruhr", "Belgium");
    try issueSupportMove(names, &game, "Germany", "Holland", "Ruhr", "Belgium");
    try issueConvoyMove(names, &game, "Germany", "Denmark", "Norway");
    try issueConvoyTransport(names, &game, "Germany", "Skagerrak", "Denmark", "Norway");
    try issueSupportMove(names, &game, "Germany", "Finland", "Denmark", "Norway");
    try issueConvoyMove(names, &game, "England", "Yorkshire", "Holland");
    try issueConvoyTransport(names, &game, "England", "North Sea", "Yorkshire", "Holland");
    try issueSupportMove(names, &game, "England", "Helgoland Bight", "Yorkshire", "Holland");
    try issueHold(names, &game, "England", "Belgium");
    try issueMove(names, &game, "Russia", "Norwegian Sea", "North Sea");
    try issueSupportMove(names, &game, "Russia", "Norway", "Norwegian Sea", "North Sea");
    try issueMove(names, &game, "Russia", "Sweden", "Skagerrak");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Russia", "Norway");
    try issueRetreatDisband(names, &game, "Germany", "Holland");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Ruhr");
    try expectUnitAtArea(game, names, "Germany", "Norway");
    try expectUnitAtArea(game, names, "England", "Holland");
    try expectUnitAtArea(game, names, "Russia", "Norwegian Sea");
    try expectUnitAtArea(game, names, "Russia", "Sweden");
}

// 6.G. TEST CASES, CONVOYING TO ADJACENT PROVINCES

test "6.G.1. TEST CASE, TWO UNITS CAN SWAP PROVINCES BY CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.infer_convoy_intent = true;

    try createArmyAt(names, &game, "England", "Norway");
    try createFleetAt(names, &game, "England", "Skagerrak");
    try createArmyAt(names, &game, "Russia", "Sweden");

    try issueMove(names, &game, "England", "Norway", "Sweden");
    try issueConvoyTransport(names, &game, "England", "Skagerrak", "Norway", "Sweden");
    try issueMove(names, &game, "Russia", "Sweden", "Norway");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Sweden");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.G.2. TEST CASE, KIDNAPPING AN ARMY" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.infer_convoy_intent = true;

        try createArmyAt(names, &game, "England", "Norway");
        try createFleetAt(names, &game, "Germany", "Skagerrak");
        try createArmyAt(names, &game, "Russia", "Sweden");

        try issueMove(names, &game, "England", "Norway", "Sweden");
        try issueConvoyTransport(names, &game, "Germany", "Skagerrak", "Norway", "Sweden");
        try issueMove(names, &game, "Russia", "Sweden", "Norway");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "Norway");
        try expectUnitAtArea(game, names, "Russia", "Sweden");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.convoy_can_fallback = true;

        try createArmyAt(names, &game, "England", "Norway");
        try createFleetAt(names, &game, "Germany", "Skagerrak");
        try createArmyAt(names, &game, "Russia", "Sweden");

        try issueConvoyMove(names, &game, "England", "Norway", "Sweden");
        try issueConvoyTransport(names, &game, "Germany", "Skagerrak", "Norway", "Sweden");
        try issueConvoyMove(names, &game, "Russia", "Sweden", "Norway");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "Sweden");
        try expectUnitAtArea(game, names, "Russia", "Norway");
    }
}

test "6.G.3. TEST CASE, AN UNWANTED DISRUPTED CONVOY TO ADJACENT PROVINCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.infer_convoy_intent = true;

    try createFleetAt(names, &game, "France", "Brest");
    try createArmyAt(names, &game, "France", "Picardy");
    try createArmyAt(names, &game, "France", "Burgundy");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
    try createFleetAt(names, &game, "England", "English Channel");

    try issueMove(names, &game, "France", "Brest", "English Channel");
    try issueMove(names, &game, "France", "Picardy", "Belgium");
    try issueSupportMove(names, &game, "France", "Burgundy", "Picardy", "Belgium");
    try issueSupportMove(names, &game, "France", "Mid-Atlantic Ocean", "Brest", "English Channel");
    try issueConvoyTransport(names, &game, "England", "English Channel", "Picardy", "Belgium");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "English Channel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "Belgium");
}

test "6.G.4. TEST CASE, AN UNWANTED DISRUPTED CONVOY TO ADJACENT PROVINCE AND OPPOSITE MOVE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.infer_convoy_intent = true;

    try createFleetAt(names, &game, "France", "Brest");
    try createArmyAt(names, &game, "France", "Picardy");
    try createArmyAt(names, &game, "France", "Burgundy");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
    try createFleetAt(names, &game, "England", "English Channel");
    try createArmyAt(names, &game, "England", "Belgium");

    try issueMove(names, &game, "France", "Brest", "English Channel");
    try issueMove(names, &game, "France", "Picardy", "Belgium");
    try issueSupportMove(names, &game, "France", "Burgundy", "Picardy", "Belgium");
    try issueSupportMove(names, &game, "France", "Mid-Atlantic Ocean", "Brest", "English Channel");
    try issueConvoyTransport(names, &game, "England", "English Channel", "Picardy", "Belgium");
    try issueMove(names, &game, "England", "Belgium", "Picardy");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "England", "English Channel");
    try issueRetreatDisband(names, &game, "England", "Belgium");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "Belgium");
}

test "6.G.5. TEST CASE, SWAPPING WITH MULTIPLE FLEETS WITH ONE OWN FLEET" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.infer_convoy_intent = true;

    try createArmyAt(names, &game, "Italy", "Rome");
    try createFleetAt(names, &game, "Italy", "Tyrrhenian Sea");
    try createArmyAt(names, &game, "Turkey", "Apulia");
    try createFleetAt(names, &game, "Turkey", "Ionian Sea");

    try issueMove(names, &game, "Italy", "Rome", "Apulia");
    try issueConvoyTransport(names, &game, "Italy", "Tyrrhenian Sea", "Apulia", "Rome");
    try issueMove(names, &game, "Turkey", "Apulia", "Rome");
    try issueConvoyTransport(names, &game, "Turkey", "Ionian Sea", "Apulia", "Rome");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Apulia");
    try expectUnitAtArea(game, names, "Turkey", "Rome");
}

test "6.G.6. TEST CASE, SWAPPING WITH UNINTENDED INTENT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.infer_convoy_intent = true;

    try createArmyAt(names, &game, "England", "Liverpool");
    try createFleetAt(names, &game, "England", "English Channel");
    try createArmyAt(names, &game, "Germany", "Edinburgh");
    try createFleetAt(names, &game, "France", "Irish Sea");
    try createFleetAt(names, &game, "France", "North Sea");
    try createFleetAt(names, &game, "Russia", "Norwegian Sea");
    try createFleetAt(names, &game, "Russia", "North Atlantic Ocean");

    try issueMove(names, &game, "England", "Liverpool", "Edinburgh");
    try issueConvoyTransport(names, &game, "England", "English Channel", "Liverpool", "Edinburgh");
    try issueMove(names, &game, "Germany", "Edinburgh", "Liverpool");
    try issueHold(names, &game, "France", "Irish Sea");
    try issueHold(names, &game, "France", "North Sea");
    try issueConvoyTransport(names, &game, "Russia", "Norwegian Sea", "Liverpool", "Edinburgh");
    try issueConvoyTransport(names, &game, "Russia", "North Atlantic Ocean", "Liverpool", "Edinburgh");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Edinburgh");
    try expectUnitAtArea(game, names, "Germany", "Liverpool");
}

test "6.G.7. TEST CASE, SWAPPING WITH ILLEGAL INTENT" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.infer_convoy_intent = true;
        game.options.illegal_commands = .throw_error;

        try createFleetAt(names, &game, "England", "Skagerrak");
        try createFleetAt(names, &game, "England", "Norway");
        try createArmyAt(names, &game, "Russia", "Sweden");
        try createFleetAt(names, &game, "Russia", "Gulf of Bothnia");

        try std.testing.expectError(error.TransportNoPath, issueConvoyTransport(names, &game, "Russia", "Gulf of Bothnia", "Sweden", "Norway")); // Illegal
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.infer_convoy_intent = true;
        game.options.illegal_commands = .treat_as_hold;

        try createFleetAt(names, &game, "England", "Skagerrak");
        try createFleetAt(names, &game, "England", "Norway");
        try createArmyAt(names, &game, "Russia", "Sweden");
        try createFleetAt(names, &game, "Russia", "Gulf of Bothnia");

        try issueConvoyTransport(names, &game, "England", "Skagerrak", "Sweden", "Norway");
        try issueMove(names, &game, "England", "Norway", "Sweden");
        try issueMove(names, &game, "Russia", "Sweden", "Norway");
        try issueConvoyTransport(names, &game, "Russia", "Gulf of Bothnia", "Sweden", "Norway"); // Illegal

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "Norway");
        try expectUnitAtArea(game, names, "Russia", "Sweden");
    }
}

test "6.G.8. TEST CASE, EXPLICIT CONVOY THAT ISN'T THERE" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.convoy_can_fallback = false;

        try createArmyAt(names, &game, "France", "Belgium");
        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Holland");

        try issueConvoyMove(names, &game, "France", "Belgium", "Holland");
        try issueMove(names, &game, "England", "North Sea", "Helgoland Bight");
        try issueMove(names, &game, "England", "Holland", "Kiel");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Belgium");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.convoy_can_fallback = true;

        try createArmyAt(names, &game, "France", "Belgium");
        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Holland");

        try issueConvoyMove(names, &game, "France", "Belgium", "Holland");
        try issueMove(names, &game, "England", "North Sea", "Helgoland Bight");
        try issueMove(names, &game, "England", "Holland", "Kiel");

        try game.adjudicateSpring();
        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Holland");
    }
}

test "6.G.9. TEST CASE, SWAPPED OR DISLODGED?" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.infer_convoy_intent = true;

    try createArmyAt(names, &game, "England", "Norway");
    try createFleetAt(names, &game, "England", "Skagerrak");
    try createFleetAt(names, &game, "England", "Finland");
    try createArmyAt(names, &game, "Russia", "Sweden");

    try issueMove(names, &game, "England", "Norway", "Sweden");
    try issueConvoyTransport(names, &game, "England", "Skagerrak", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Finland", "Norway", "Sweden");
    try issueMove(names, &game, "Russia", "Sweden", "Norway");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Sweden");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.G.10. TEST CASE, SWAPPED OR AN HEAD-TO-HEAD BATTLE?" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Norway");
    try createFleetAt(names, &game, "England", "Denmark");
    try createFleetAt(names, &game, "England", "Finland");
    try createFleetAt(names, &game, "Germany", "Skagerrak");
    try createArmyAt(names, &game, "Russia", "Sweden");
    try createFleetAt(names, &game, "Russia", "Barents Sea");
    try createFleetAt(names, &game, "France", "Norwegian Sea");
    try createFleetAt(names, &game, "France", "North Sea");

    try issueConvoyMove(names, &game, "England", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Denmark", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Finland", "Norway", "Sweden");
    try issueConvoyTransport(names, &game, "Germany", "Skagerrak", "Norway", "Sweden");
    try issueMove(names, &game, "Russia", "Sweden", "Norway");
    try issueSupportMove(names, &game, "Russia", "Barents Sea", "Sweden", "Norway");
    try issueMove(names, &game, "France", "Norwegian Sea", "Norway");
    try issueSupportMove(names, &game, "France", "North Sea", "Norwegian Sea", "Norway");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Russia", "Sweden");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Sweden");
    try expectUnitAtArea(game, names, "France", "Norwegian Sea");
}

test "6.G.11. TEST CASE, A CONVOY TO AN ADJACENT PROVINCE WITH A PARADOX" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.convoy_can_fallback = false;

        try createFleetAt(names, &game, "England", "Norway");
        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "Russia", "Sweden");
        try createFleetAt(names, &game, "Russia", "Skagerrak");
        try createFleetAt(names, &game, "Russia", "Barents Sea");

        try issueSupportMove(names, &game, "England", "Norway", "North Sea", "Skagerrak");
        try issueMove(names, &game, "England", "North Sea", "Skagerrak");
        try issueConvoyMove(names, &game, "Russia", "Sweden", "Norway");
        try issueConvoyTransport(names, &game, "Russia", "Skagerrak", "Sweden", "Norway");
        try issueSupportMove(names, &game, "Russia", "Barents Sea", "Sweden", "Norway");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "Russia", "Skagerrak");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "England", "Skagerrak");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.convoy_can_fallback = true;

        try createFleetAt(names, &game, "England", "Norway");
        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "Russia", "Sweden");
        try createFleetAt(names, &game, "Russia", "Skagerrak");
        try createFleetAt(names, &game, "Russia", "Barents Sea");

        try issueSupportMove(names, &game, "England", "Norway", "North Sea", "Skagerrak");
        try issueMove(names, &game, "England", "North Sea", "Skagerrak");
        try issueConvoyMove(names, &game, "Russia", "Sweden", "Norway");
        try issueConvoyTransport(names, &game, "Russia", "Skagerrak", "Sweden", "Norway");
        try issueSupportMove(names, &game, "Russia", "Barents Sea", "Sweden", "Norway");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "England", "Norway");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Russia", "Norway");
    }
}

test "6.G.12. TEST CASE, SWAPPING TWO UNITS WITH TWO CONVOYS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Liverpool");
    try createFleetAt(names, &game, "England", "North Atlantic Ocean");
    try createFleetAt(names, &game, "England", "Norwegian Sea");
    try createArmyAt(names, &game, "Germany", "Edinburgh");
    try createFleetAt(names, &game, "Germany", "North Sea");
    try createFleetAt(names, &game, "Germany", "English Channel");
    try createFleetAt(names, &game, "Germany", "Irish Sea");

    try issueConvoyMove(names, &game, "England", "Liverpool", "Edinburgh");
    try issueConvoyTransport(names, &game, "England", "North Atlantic Ocean", "Liverpool", "Edinburgh");
    try issueConvoyTransport(names, &game, "England", "Norwegian Sea", "Liverpool", "Edinburgh");
    try issueConvoyMove(names, &game, "Germany", "Edinburgh", "Liverpool");
    try issueConvoyTransport(names, &game, "Germany", "North Sea", "Edinburgh", "Liverpool");
    try issueConvoyTransport(names, &game, "Germany", "English Channel", "Edinburgh", "Liverpool");
    try issueConvoyTransport(names, &game, "Germany", "Irish Sea", "Edinburgh", "Liverpool");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Edinburgh");
    try expectUnitAtArea(game, names, "Germany", "Liverpool");
}

test "6.G.13. TEST CASE, SUPPORT CUT ON ATTACK ON ITSELF VIA CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Adriatic Sea");
    try createArmyAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createFleetAt(names, &game, "Italy", "Albania");

    try issueConvoyMove(names, &game, "Austria", "Trieste", "Venice");
    try issueConvoyTransport(names, &game, "Austria", "Adriatic Sea", "Trieste", "Venice");
    try issueMove(names, &game, "Italy", "Albania", "Trieste");
    try issueSupportMove(names, &game, "Italy", "Venice", "Albania", "Trieste");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Austria", "Trieste");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Italy", "Trieste");
}

test "6.G.14. TEST CASE, BOUNCE BY CONVOY TO ADJACENT PROVINCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Norway");
    try createFleetAt(names, &game, "England", "Denmark");
    try createFleetAt(names, &game, "England", "Finland");
    try createFleetAt(names, &game, "France", "Norwegian Sea");
    try createFleetAt(names, &game, "France", "North Sea");
    try createFleetAt(names, &game, "Germany", "Skagerrak");
    try createArmyAt(names, &game, "Russia", "Sweden");
    try createFleetAt(names, &game, "Russia", "Barents Sea");

    try issueMove(names, &game, "England", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Denmark", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Finland", "Norway", "Sweden");
    try issueMove(names, &game, "France", "Norwegian Sea", "Norway");
    try issueSupportMove(names, &game, "France", "North Sea", "Norwegian Sea", "Norway");
    try issueConvoyTransport(names, &game, "Germany", "Skagerrak", "Sweden", "Norway");
    try issueConvoyMove(names, &game, "Russia", "Sweden", "Norway");
    try issueSupportMove(names, &game, "Russia", "Barents Sea", "Sweden", "Norway");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "Russia", "Sweden");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Sweden");
    try expectUnitAtArea(game, names, "France", "Norwegian Sea");
}

test "6.G.15. TEST CASE, BOUNCE AND DISLODGE WITH DOUBLE CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "North Sea");
    try createArmyAt(names, &game, "England", "Holland");
    try createArmyAt(names, &game, "England", "Yorkshire");
    try createArmyAt(names, &game, "England", "London");
    try createFleetAt(names, &game, "France", "English Channel");
    try createArmyAt(names, &game, "France", "Belgium");

    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium");
    try issueSupportMove(names, &game, "England", "Holland", "London", "Belgium");
    try issueMove(names, &game, "England", "Yorkshire", "London");
    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Belgium", "London");
    try issueConvoyMove(names, &game, "France", "Belgium", "London");

    try game.adjudicateSpring();

    try issueRetreatDisband(names, &game, "France", "Belgium");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Belgium");
    try expectUnitAtArea(game, names, "England", "Yorkshire");
}

test "6.G.16. TEST CASE, THE TWO UNIT IN ONE AREA BUG, MOVING BY CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Norway");
    try createArmyAt(names, &game, "England", "Denmark");
    try createFleetAt(names, &game, "England", "Baltic Sea");
    try createFleetAt(names, &game, "England", "North Sea");
    try createArmyAt(names, &game, "Russia", "Sweden");
    try createFleetAt(names, &game, "Russia", "Skagerrak");
    try createFleetAt(names, &game, "Russia", "Norwegian Sea");

    try issueMove(names, &game, "England", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Denmark", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Baltic Sea", "Norway", "Sweden");
    try issueMove(names, &game, "England", "North Sea", "Norway");
    try issueConvoyMove(names, &game, "Russia", "Sweden", "Norway");
    try issueConvoyTransport(names, &game, "Russia", "Skagerrak", "Sweden", "Norway");
    try issueSupportMove(names, &game, "Russia", "Norwegian Sea", "Sweden", "Norway");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Sweden");
    try expectUnitAtArea(game, names, "England", "North Sea");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.G.17. TEST CASE, THE TWO UNIT IN ONE AREA BUG, MOVING OVER LAND" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Norway");
    try createArmyAt(names, &game, "England", "Denmark");
    try createFleetAt(names, &game, "England", "Baltic Sea");
    try createFleetAt(names, &game, "England", "Skagerrak");
    try createFleetAt(names, &game, "England", "North Sea");
    try createArmyAt(names, &game, "Russia", "Sweden");
    try createFleetAt(names, &game, "Russia", "Norwegian Sea");

    try issueConvoyMove(names, &game, "England", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Denmark", "Norway", "Sweden");
    try issueSupportMove(names, &game, "England", "Baltic Sea", "Norway", "Sweden");
    try issueConvoyTransport(names, &game, "England", "Skagerrak", "Norway", "Sweden");
    try issueMove(names, &game, "England", "North Sea", "Norway");
    try issueMove(names, &game, "Russia", "Sweden", "Norway");
    try issueSupportMove(names, &game, "Russia", "Norwegian Sea", "Sweden", "Norway");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Sweden");
    try expectUnitAtArea(game, names, "England", "North Sea");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.G.18. TEST CASE, THE TWO UNIT IN ONE AREA BUG, WITH DOUBLE CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "North Sea");
    try createArmyAt(names, &game, "England", "Holland");
    try createArmyAt(names, &game, "England", "Yorkshire");
    try createArmyAt(names, &game, "England", "London");
    try createArmyAt(names, &game, "England", "Ruhr");
    try createFleetAt(names, &game, "France", "English Channel");
    try createArmyAt(names, &game, "France", "Belgium");
    try createArmyAt(names, &game, "France", "Wales");

    try issueConvoyTransport(names, &game, "England", "North Sea", "London", "Belgium");
    try issueSupportMove(names, &game, "England", "Holland", "London", "Belgium");
    try issueMove(names, &game, "England", "Yorkshire", "London");
    try issueConvoyMove(names, &game, "England", "London", "Belgium");
    try issueSupportMove(names, &game, "England", "Ruhr", "London", "Belgium");
    try issueConvoyTransport(names, &game, "France", "English Channel", "Belgium", "London");
    try issueConvoyMove(names, &game, "France", "Belgium", "London");
    try issueSupportMove(names, &game, "France", "Wales", "Belgium", "London");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Yorkshire");
    try expectUnitAtArea(game, names, "England", "Belgium");
    try expectUnitAtArea(game, names, "France", "London");
}

test "6.G.19. TEST CASE, SWAPPING WITH INTENT OF UNNECESSARY CONVOY" {
    // TODO: Think about strict_transport_legality option. For now non-required transports are legal and can show intent.
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.infer_convoy_intent = true;

    try createArmyAt(names, &game, "France", "Marseilles");
    try createFleetAt(names, &game, "France", "Western Mediterranean Sea");
    try createFleetAt(names, &game, "Italy", "Gulf of Lyon");
    try createArmyAt(names, &game, "Italy", "Spain");

    try issueMove(names, &game, "France", "Marseilles", "Spain");
    try issueConvoyTransport(names, &game, "France", "Western Mediterranean Sea", "Marseilles", "Spain"); // Legal for now
    try issueConvoyTransport(names, &game, "Italy", "Gulf of Lyon", "Marseilles", "Spain");
    try issueMove(names, &game, "Italy", "Spain", "Marseilles");

    try game.adjudicateSpring();
    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "Spain");
    try expectUnitAtArea(game, names, "Italy", "Marseilles");
}

test "6.G.20. TEST CASE, EXPLICIT CONVOY TO ADJACENT PROVINCE DISRUPTED" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.convoy_can_fallback = false;

        try createFleetAt(names, &game, "France", "Brest");
        try createArmyAt(names, &game, "France", "Picardy");
        try createArmyAt(names, &game, "France", "Burgundy");
        try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
        try createFleetAt(names, &game, "England", "English Channel");

        try issueMove(names, &game, "France", "Brest", "English Channel");
        try issueConvoyMove(names, &game, "France", "Picardy", "Belgium");
        try issueSupportMove(names, &game, "France", "Burgundy", "Picardy", "Belgium");
        try issueSupportMove(names, &game, "France", "Mid-Atlantic Ocean", "Brest", "English Channel");
        try issueConvoyTransport(names, &game, "England", "English Channel", "Picardy", "Belgium");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "England", "English Channel");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Picardy");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.convoy_can_fallback = true;

        try createFleetAt(names, &game, "France", "Brest");
        try createArmyAt(names, &game, "France", "Picardy");
        try createArmyAt(names, &game, "France", "Burgundy");
        try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
        try createFleetAt(names, &game, "England", "English Channel");

        try issueMove(names, &game, "France", "Brest", "English Channel");
        try issueConvoyMove(names, &game, "France", "Picardy", "Belgium");
        try issueSupportMove(names, &game, "France", "Burgundy", "Picardy", "Belgium");
        try issueSupportMove(names, &game, "France", "Mid-Atlantic Ocean", "Brest", "English Channel");
        try issueConvoyTransport(names, &game, "England", "English Channel", "Picardy", "Belgium");

        try game.adjudicateSpring();

        try issueRetreatDisband(names, &game, "England", "English Channel");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Belgium");
    }
}

// 6.H. TEST CASES, RETREATING

test "6.H.1. TEST CASE, NO SUPPORTS DURING RETREAT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Austria", "Serbia");
    try createFleetAt(names, &game, "Turkey", "Greece");
    try createArmyAt(names, &game, "Italy", "Venice");
    try createArmyAt(names, &game, "Italy", "Tyrolia");
    try createFleetAt(names, &game, "Italy", "Ionian Sea");
    try createFleetAt(names, &game, "Italy", "Aegean Sea");

    try issueHold(names, &game, "Austria", "Trieste");
    try issueHold(names, &game, "Austria", "Serbia");
    try issueHold(names, &game, "Turkey", "Greece");
    try issueSupportMove(names, &game, "Italy", "Venice", "Tyrolia", "Trieste");
    try issueMove(names, &game, "Italy", "Tyrolia", "Trieste");
    try issueMove(names, &game, "Italy", "Ionian Sea", "Greece");
    try issueSupportMove(names, &game, "Italy", "Aegean Sea", "Ionian Sea", "Greece");

    try game.adjudicateSpring();

    try issueRetreat(names, &game, "Austria", "Trieste", "Albania");
    try std.testing.expectError(error.WrongPhase, issueSupportMove(names, &game, "Austria", "Serbia", "Trieste", "Albania"));
    try issueRetreat(names, &game, "Turkey", "Greece", "Albania");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectEmptyAtArea(game, names, "Albania");
    try expectUnitAtArea(game, names, "Italy", "Greece");
    try expectUnitAtArea(game, names, "Italy", "Trieste");
}

test "6.H.2. TEST CASE, NO SUPPORTS FROM RETREATING UNIT" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Liverpool");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "England", "Norway");
    try createArmyAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Ruhr");
    try createFleetAt(names, &game, "Russia", "Edinburgh");
    try createArmyAt(names, &game, "Russia", "Sweden");
    try createArmyAt(names, &game, "Russia", "Finland");
    try createFleetAt(names, &game, "Russia", "Holland");

    try issueMove(names, &game, "England", "Liverpool", "Edinburgh");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Liverpool", "Edinburgh");
    try issueHold(names, &game, "England", "Norway");
    try issueSupportMove(names, &game, "Germany", "Kiel", "Ruhr", "Holland");
    try issueMove(names, &game, "Germany", "Ruhr", "Holland");
    try issueHold(names, &game, "Russia", "Edinburgh");
    try issueSupportMove(names, &game, "Russia", "Sweden", "Finland", "Norway");
    try issueMove(names, &game, "Russia", "Finland", "Norway");
    try issueHold(names, &game, "Russia", "Holland");

    try game.adjudicateSpring();

    game.options.missing_orders = .issue_defaults;

    try issueRetreat(names, &game, "England", "Norway", "North Sea");
    try issueRetreat(names, &game, "Russia", "Edinburgh", "North Sea");
    try std.testing.expectError(error.WrongPhase, issueSupportMove(names, &game, "Russia", "Holland", "Edinburgh", "North Sea"));

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectEmptyAtArea(game, names, "North Sea");
    try expectUnitAtArea(game, names, "England", "Edinburgh");
    try expectUnitAtArea(game, names, "Germany", "Holland");
    try expectUnitAtArea(game, names, "Russia", "Norway");
}

test "6.H.3. TEST CASE, NO CONVOY DURING RETREAT" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .throw_error;

        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Holland");
        try createFleetAt(names, &game, "Germany", "Kiel");
        try createArmyAt(names, &game, "Germany", "Ruhr");

        try issueHold(names, &game, "England", "North Sea");
        try issueHold(names, &game, "England", "Holland");
        try issueSupportMove(names, &game, "Germany", "Kiel", "Ruhr", "Holland");
        try issueMove(names, &game, "Germany", "Ruhr", "Holland");

        try game.adjudicateSpring();

        try std.testing.expectError(error.NoBorder, issueRetreat(names, &game, "England", "Holland", "Yorkshire"));
        try std.testing.expectError(error.WrongPhase, issueConvoyTransport(names, &game, "England", "North Sea", "Holland", "Yorkshire"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .treat_as_disband;

        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Holland");
        try createFleetAt(names, &game, "Germany", "Kiel");
        try createArmyAt(names, &game, "Germany", "Ruhr");

        try issueHold(names, &game, "England", "North Sea");
        try issueHold(names, &game, "England", "Holland");
        try issueSupportMove(names, &game, "Germany", "Kiel", "Ruhr", "Holland");
        try issueMove(names, &game, "Germany", "Ruhr", "Holland");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "England", "Holland", "Yorkshire"); // Illegal
        try std.testing.expectError(error.WrongPhase, issueConvoyTransport(names, &game, "England", "North Sea", "Holland", "Yorkshire"));

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectEmptyAtArea(game, names, "Yorkshire");
        try expectUnitAtArea(game, names, "Germany", "Holland");
    }
}

test "6.H.4. TEST CASE, NO OTHER MOVES DURING RETREAT" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .throw_error;

        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Holland");
        try createFleetAt(names, &game, "Germany", "Kiel");
        try createArmyAt(names, &game, "Germany", "Ruhr");

        try issueHold(names, &game, "England", "North Sea");
        try issueHold(names, &game, "England", "Holland");
        try issueSupportMove(names, &game, "Germany", "Kiel", "Ruhr", "Holland");
        try issueMove(names, &game, "Germany", "Ruhr", "Holland");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "England", "Holland", "Belgium");
        try std.testing.expectError(error.NotDislodged, issueRetreat(names, &game, "England", "North Sea", "Norwegian Sea"));

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Germany", "Holland");
        try expectUnitAtArea(game, names, "England", "Belgium");
        try expectUnitAtArea(game, names, "England", "North Sea");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .treat_as_disband;

        try createFleetAt(names, &game, "England", "North Sea");
        try createArmyAt(names, &game, "England", "Holland");
        try createFleetAt(names, &game, "Germany", "Kiel");
        try createArmyAt(names, &game, "Germany", "Ruhr");

        try issueHold(names, &game, "England", "North Sea");
        try issueHold(names, &game, "England", "Holland");
        try issueSupportMove(names, &game, "Germany", "Kiel", "Ruhr", "Holland");
        try issueMove(names, &game, "Germany", "Ruhr", "Holland");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "England", "Holland", "Belgium");
        try issueRetreat(names, &game, "England", "North Sea", "Norwegian Sea"); // Illegal

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Germany", "Holland");
        try expectUnitAtArea(game, names, "England", "Belgium");
        try expectUnitAtArea(game, names, "England", "North Sea");
    }
}

test "6.H.5. TEST CASE, A UNIT MAY NOT RETREAT TO THE AREA FROM WHICH IT IS ATTACKED" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .throw_error;

        try createFleetAt(names, &game, "Russia", "Constantinople");
        try createFleetAt(names, &game, "Russia", "Black Sea");
        try createFleetAt(names, &game, "Turkey", "Ankara");

        try issueSupportMove(names, &game, "Russia", "Constantinople", "Black Sea", "Ankara");
        try issueMove(names, &game, "Russia", "Black Sea", "Ankara");
        try issueHold(names, &game, "Turkey", "Ankara");

        try game.adjudicateSpring();

        try std.testing.expectError(error.HeadToHead, issueRetreat(names, &game, "Turkey", "Ankara", "Black Sea"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .treat_as_disband;

        try createFleetAt(names, &game, "Russia", "Constantinople");
        try createFleetAt(names, &game, "Russia", "Black Sea");
        try createFleetAt(names, &game, "Turkey", "Ankara");

        try issueSupportMove(names, &game, "Russia", "Constantinople", "Black Sea", "Ankara");
        try issueMove(names, &game, "Russia", "Black Sea", "Ankara");
        try issueHold(names, &game, "Turkey", "Ankara");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "Turkey", "Ankara", "Black Sea"); // Illegal

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Russia", "Ankara");
        try expectEmptyAtArea(game, names, "Black Sea");
    }
}

test "6.H.6. TEST CASE, UNIT MAY NOT RETREAT TO A CONTESTED AREA" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .throw_error;

        try createArmyAt(names, &game, "Austria", "Budapest");
        try createArmyAt(names, &game, "Austria", "Trieste");
        try createArmyAt(names, &game, "Germany", "Munich");
        try createArmyAt(names, &game, "Germany", "Silesia");
        try createArmyAt(names, &game, "Italy", "Vienna");

        try issueSupportMove(names, &game, "Austria", "Budapest", "Trieste", "Vienna");
        try issueMove(names, &game, "Austria", "Trieste", "Vienna");
        try issueMove(names, &game, "Germany", "Munich", "Bohemia");
        try issueMove(names, &game, "Germany", "Silesia", "Bohemia");
        try issueHold(names, &game, "Italy", "Vienna");

        try game.adjudicateSpring();

        try std.testing.expectError(error.BusyArea, issueRetreat(names, &game, "Italy", "Vienna", "Bohemia"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .treat_as_disband;

        try createArmyAt(names, &game, "Austria", "Budapest");
        try createArmyAt(names, &game, "Austria", "Trieste");
        try createArmyAt(names, &game, "Germany", "Munich");
        try createArmyAt(names, &game, "Germany", "Silesia");
        try createArmyAt(names, &game, "Italy", "Vienna");

        try issueSupportMove(names, &game, "Austria", "Budapest", "Trieste", "Vienna");
        try issueMove(names, &game, "Austria", "Trieste", "Vienna");
        try issueMove(names, &game, "Germany", "Munich", "Bohemia");
        try issueMove(names, &game, "Germany", "Silesia", "Bohemia");
        try issueHold(names, &game, "Italy", "Vienna");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "Italy", "Vienna", "Bohemia"); // Illegal

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Austria", "Vienna");
        try expectEmptyAtArea(game, names, "Bohemia");
    }
}

test "6.H.7. TEST CASE, MULTIPLE RETREAT TO SAME AREA WILL DISBAND UNITS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "Austria", "Budapest");
    try createArmyAt(names, &game, "Austria", "Trieste");
    try createArmyAt(names, &game, "Germany", "Munich");
    try createArmyAt(names, &game, "Germany", "Silesia");
    try createArmyAt(names, &game, "Italy", "Vienna");
    try createArmyAt(names, &game, "Italy", "Bohemia");

    try issueSupportMove(names, &game, "Austria", "Budapest", "Trieste", "Vienna");
    try issueMove(names, &game, "Austria", "Trieste", "Vienna");
    try issueSupportMove(names, &game, "Germany", "Munich", "Silesia", "Bohemia");
    try issueMove(names, &game, "Germany", "Silesia", "Bohemia");
    try issueHold(names, &game, "Italy", "Vienna");
    try issueHold(names, &game, "Italy", "Bohemia");

    try game.adjudicateSpring();

    try issueRetreat(names, &game, "Italy", "Vienna", "Tyrolia");
    try issueRetreat(names, &game, "Italy", "Bohemia", "Tyrolia");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectEmptyAtArea(game, names, "Tyrolia");
    try expectUnitAtArea(game, names, "Austria", "Vienna");
    try expectUnitAtArea(game, names, "Germany", "Bohemia");
}

test "6.H.8. TEST CASE, TRIPLE RETREAT TO SAME AREA WILL DISBAND UNITS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Liverpool");
    try createFleetAt(names, &game, "England", "Yorkshire");
    try createFleetAt(names, &game, "England", "Norway");
    try createArmyAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Ruhr");
    try createFleetAt(names, &game, "Russia", "Edinburgh");
    try createArmyAt(names, &game, "Russia", "Sweden");
    try createArmyAt(names, &game, "Russia", "Finland");
    try createFleetAt(names, &game, "Russia", "Holland");

    try issueMove(names, &game, "England", "Liverpool", "Edinburgh");
    try issueSupportMove(names, &game, "England", "Yorkshire", "Liverpool", "Edinburgh");
    try issueHold(names, &game, "England", "Norway");
    try issueSupportMove(names, &game, "Germany", "Kiel", "Ruhr", "Holland");
    try issueMove(names, &game, "Germany", "Ruhr", "Holland");
    try issueHold(names, &game, "Russia", "Edinburgh");
    try issueSupportMove(names, &game, "Russia", "Sweden", "Finland", "Norway");
    try issueMove(names, &game, "Russia", "Finland", "Norway");
    try issueHold(names, &game, "Russia", "Holland");

    try game.adjudicateSpring();

    try issueRetreat(names, &game, "England", "Norway", "North Sea");
    try issueRetreat(names, &game, "Russia", "Edinburgh", "North Sea");
    try issueRetreat(names, &game, "Russia", "Holland", "North Sea");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectEmptyAtArea(game, names, "North Sea");
    try expectUnitAtArea(game, names, "Russia", "Norway");
    try expectUnitAtArea(game, names, "Germany", "Holland");
    try expectUnitAtArea(game, names, "England", "Edinburgh");
}

test "6.H.9. TEST CASE, DISLODGED UNIT WILL NOT MAKE ATTACKERS AREA CONTESTED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createFleetAt(names, &game, "England", "Helgoland Bight");
    try createFleetAt(names, &game, "England", "Denmark");
    try createArmyAt(names, &game, "Germany", "Berlin");
    try createFleetAt(names, &game, "Germany", "Kiel");
    try createArmyAt(names, &game, "Germany", "Silesia");
    try createArmyAt(names, &game, "Russia", "Prussia");

    try issueMove(names, &game, "England", "Helgoland Bight", "Kiel");
    try issueSupportMove(names, &game, "England", "Denmark", "Helgoland Bight", "Kiel");
    try issueMove(names, &game, "Germany", "Berlin", "Prussia");
    try issueHold(names, &game, "Germany", "Kiel");
    try issueSupportMove(names, &game, "Germany", "Silesia", "Berlin", "Prussia");
    try issueMove(names, &game, "Russia", "Prussia", "Berlin");

    try game.adjudicateSpring();

    try issueRetreat(names, &game, "Germany", "Kiel", "Berlin");
    try issueRetreatDisband(names, &game, "Russia", "Prussia");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "Germany", "Berlin");
    try expectUnitAtArea(game, names, "Germany", "Prussia");
}

test "6.H.10. TEST CASE, NOT RETREATING TO ATTACKER DOES NOT MEAN CONTESTED" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .throw_error;

        try createArmyAt(names, &game, "England", "Kiel");
        try createArmyAt(names, &game, "Germany", "Berlin");
        try createArmyAt(names, &game, "Germany", "Munich");
        try createArmyAt(names, &game, "Germany", "Prussia");
        try createArmyAt(names, &game, "Russia", "Warsaw");
        try createArmyAt(names, &game, "Russia", "Silesia");

        try issueHold(names, &game, "England", "Kiel");
        try issueMove(names, &game, "Germany", "Berlin", "Kiel");
        try issueSupportMove(names, &game, "Germany", "Munich", "Berlin", "Kiel");
        try issueHold(names, &game, "Germany", "Prussia");
        try issueMove(names, &game, "Russia", "Warsaw", "Prussia");
        try issueSupportMove(names, &game, "Russia", "Silesia", "Warsaw", "Prussia");

        try game.adjudicateSpring();

        try std.testing.expectError(error.HeadToHead, issueRetreat(names, &game, "England", "Kiel", "Berlin"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .treat_as_disband;

        try createArmyAt(names, &game, "England", "Kiel");
        try createArmyAt(names, &game, "Germany", "Berlin");
        try createArmyAt(names, &game, "Germany", "Munich");
        try createArmyAt(names, &game, "Germany", "Prussia");
        try createArmyAt(names, &game, "Russia", "Warsaw");
        try createArmyAt(names, &game, "Russia", "Silesia");

        try issueHold(names, &game, "England", "Kiel");
        try issueMove(names, &game, "Germany", "Berlin", "Kiel");
        try issueSupportMove(names, &game, "Germany", "Munich", "Berlin", "Kiel");
        try issueHold(names, &game, "Germany", "Prussia");
        try issueMove(names, &game, "Russia", "Warsaw", "Prussia");
        try issueSupportMove(names, &game, "Russia", "Silesia", "Warsaw", "Prussia");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "England", "Kiel", "Berlin"); // Illegal
        try issueRetreat(names, &game, "Germany", "Prussia", "Berlin");

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "Germany", "Kiel");
        try expectUnitAtArea(game, names, "Germany", "Berlin");
        try expectUnitAtArea(game, names, "Russia", "Prussia");
    }
}

test "6.H.11. TEST CASE, RETREAT WHEN DISLODGED BY ADJACENT CONVOY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "France", "Gascony");
    try createArmyAt(names, &game, "France", "Burgundy");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
    try createFleetAt(names, &game, "France", "Western Mediterranean Sea");
    try createFleetAt(names, &game, "France", "Gulf of Lyon");
    try createArmyAt(names, &game, "Italy", "Marseilles");

    try issueConvoyMove(names, &game, "France", "Gascony", "Marseilles");
    try issueSupportMove(names, &game, "France", "Burgundy", "Gascony", "Marseilles");
    try issueConvoyTransport(names, &game, "France", "Mid-Atlantic Ocean", "Gascony", "Marseilles");
    try issueConvoyTransport(names, &game, "France", "Western Mediterranean Sea", "Gascony", "Marseilles");
    try issueConvoyTransport(names, &game, "France", "Gulf of Lyon", "Gascony", "Marseilles");
    try issueHold(names, &game, "Italy", "Marseilles");

    try game.adjudicateSpring();

    try issueRetreat(names, &game, "Italy", "Marseilles", "Gascony");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "France", "Marseilles");
    try expectUnitAtArea(game, names, "Italy", "Gascony");
}

test "6.H.12. TEST CASE, RETREAT WHEN DISLODGED BY ADJACENT CONVOY WHILE TRYING TO DO THE SAME" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Liverpool");
    try createFleetAt(names, &game, "England", "Irish Sea");
    try createFleetAt(names, &game, "England", "English Channel");
    try createFleetAt(names, &game, "England", "North Sea");
    try createFleetAt(names, &game, "France", "Brest");
    try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
    try createArmyAt(names, &game, "Russia", "Edinburgh");
    try createFleetAt(names, &game, "Russia", "Norwegian Sea");
    try createFleetAt(names, &game, "Russia", "North Atlantic Ocean");
    try createArmyAt(names, &game, "Russia", "Clyde");

    try issueConvoyMove(names, &game, "England", "Liverpool", "Edinburgh");
    try issueConvoyTransport(names, &game, "England", "Irish Sea", "Liverpool", "Edinburgh");
    try issueConvoyTransport(names, &game, "England", "English Channel", "Liverpool", "Edinburgh");
    try issueConvoyTransport(names, &game, "England", "North Sea", "Liverpool", "Edinburgh");
    try issueMove(names, &game, "France", "Brest", "English Channel");
    try issueSupportMove(names, &game, "France", "Mid-Atlantic Ocean", "Brest", "English Channel");
    try issueConvoyMove(names, &game, "Russia", "Edinburgh", "Liverpool");
    try issueConvoyTransport(names, &game, "Russia", "Norwegian Sea", "Edinburgh", "Liverpool");
    try issueConvoyTransport(names, &game, "Russia", "North Atlantic Ocean", "Edinburgh", "Liverpool");
    try issueSupportMove(names, &game, "Russia", "Clyde", "Edinburgh", "Liverpool");

    try game.adjudicateSpring();

    try issueRetreat(names, &game, "England", "Liverpool", "Edinburgh");
    try issueRetreatDisband(names, &game, "England", "English Channel");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectUnitAtArea(game, names, "England", "Edinburgh");
    try expectUnitAtArea(game, names, "Russia", "Liverpool");
    try expectUnitAtArea(game, names, "France", "English Channel");
}

test "6.H.13. TEST CASE, NO RETREAT WITH CONVOY IN MOVEMENT PHASE" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .throw_error;

        try createArmyAt(names, &game, "England", "Picardy");
        try createFleetAt(names, &game, "England", "English Channel");
        try createArmyAt(names, &game, "France", "Paris");
        try createArmyAt(names, &game, "France", "Brest");

        try issueHold(names, &game, "England", "Picardy");
        try issueConvoyTransport(names, &game, "England", "English Channel", "Picardy", "London");
        try issueMove(names, &game, "France", "Paris", "Picardy");
        try issueSupportMove(names, &game, "France", "Brest", "Paris", "Picardy");

        try game.adjudicateSpring();

        try std.testing.expectError(error.NoBorder, issueRetreat(names, &game, "England", "Picardy", "London"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .treat_as_disband;

        try createArmyAt(names, &game, "England", "Picardy");
        try createFleetAt(names, &game, "England", "English Channel");
        try createArmyAt(names, &game, "France", "Paris");
        try createArmyAt(names, &game, "France", "Brest");

        try issueHold(names, &game, "England", "Picardy");
        try issueConvoyTransport(names, &game, "England", "English Channel", "Picardy", "London");
        try issueMove(names, &game, "France", "Paris", "Picardy");
        try issueSupportMove(names, &game, "France", "Brest", "Paris", "Picardy");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "England", "Picardy", "London"); // Illegal

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectUnitAtArea(game, names, "France", "Picardy");
        try expectEmptyAtArea(game, names, "London");
    }
}

test "6.H.14. TEST CASE, NO RETREAT WITH SUPPORT IN MOVEMENT PHASE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try createArmyAt(names, &game, "England", "Picardy");
    try createFleetAt(names, &game, "England", "English Channel");
    try createArmyAt(names, &game, "France", "Paris");
    try createArmyAt(names, &game, "France", "Brest");
    try createArmyAt(names, &game, "France", "Burgundy");
    try createArmyAt(names, &game, "Germany", "Munich");
    try createArmyAt(names, &game, "Germany", "Marseilles");

    try issueHold(names, &game, "England", "Picardy");
    try issueSupportMove(names, &game, "England", "English Channel", "Picardy", "Belgium");
    try issueMove(names, &game, "France", "Paris", "Picardy");
    try issueSupportMove(names, &game, "France", "Brest", "Paris", "Picardy");
    try issueHold(names, &game, "France", "Burgundy");
    try issueSupportMove(names, &game, "Germany", "Munich", "Marseilles", "Burgundy");
    try issueMove(names, &game, "Germany", "Marseilles", "Burgundy");

    try game.adjudicateSpring();

    try issueRetreat(names, &game, "England", "Picardy", "Belgium");
    try issueRetreat(names, &game, "France", "Burgundy", "Belgium");

    try game.adjudicateSpringRetreats();
    try game.stepSpring();

    try expectEmptyAtArea(game, names, "Belgium");
    try expectUnitAtArea(game, names, "France", "Picardy");
    try expectUnitAtArea(game, names, "Germany", "Burgundy");
}

test "6.H.15. TEST CASE, NO COASTAL CRAWL IN RETREAT" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .throw_error;

        try createFleetAt(names, &game, "England", "Portugal");
        try createFleetAt(names, &game, "France", "Spain South Coast");
        try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");

        try issueHold(names, &game, "England", "Portugal");
        try issueMove(names, &game, "France", "Spain South Coast", "Portugal");
        try issueSupportMove(names, &game, "France", "Mid-Atlantic Ocean", "Spain South Coast", "Portugal");

        try game.adjudicateSpring();

        try std.testing.expectError(error.HeadToHead, issueRetreat(names, &game, "England", "Portugal", "Spain North Coast"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .treat_as_disband;

        try createFleetAt(names, &game, "England", "Portugal");
        try createFleetAt(names, &game, "France", "Spain South Coast");
        try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");

        try issueHold(names, &game, "England", "Portugal");
        try issueMove(names, &game, "France", "Spain South Coast", "Portugal");
        try issueSupportMove(names, &game, "France", "Mid-Atlantic Ocean", "Spain South Coast", "Portugal");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "England", "Portugal", "Spain North Coast"); // Illegal

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectEmptyAtArea(game, names, "Spain");
        try expectUnitAtArea(game, names, "France", "Portugal");
    }
}

test "6.H.16. TEST CASE, CONTESTED FOR BOTH COASTS" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .throw_error;

        try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
        try createFleetAt(names, &game, "France", "Gascony");
        try createFleetAt(names, &game, "France", "Western Mediterranean Sea");
        try createFleetAt(names, &game, "Italy", "Tunis");
        try createFleetAt(names, &game, "Italy", "Tyrrhenian Sea");

        try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "Spain North Coast");
        try issueMove(names, &game, "France", "Gascony", "Spain North Coast");
        try issueHold(names, &game, "France", "Western Mediterranean Sea");
        try issueSupportMove(names, &game, "Italy", "Tunis", "Tyrrhenian Sea", "Western Mediterranean Sea");
        try issueMove(names, &game, "Italy", "Tyrrhenian Sea", "Western Mediterranean Sea");

        try game.adjudicateSpring();

        try std.testing.expectError(error.BusyArea, issueRetreat(names, &game, "France", "Western Mediterranean Sea", "Spain South Coast"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.illegal_retreats = .treat_as_disband;

        try createFleetAt(names, &game, "France", "Mid-Atlantic Ocean");
        try createFleetAt(names, &game, "France", "Gascony");
        try createFleetAt(names, &game, "France", "Western Mediterranean Sea");
        try createFleetAt(names, &game, "Italy", "Tunis");
        try createFleetAt(names, &game, "Italy", "Tyrrhenian Sea");

        try issueMove(names, &game, "France", "Mid-Atlantic Ocean", "Spain North Coast");
        try issueMove(names, &game, "France", "Gascony", "Spain North Coast");
        try issueHold(names, &game, "France", "Western Mediterranean Sea");
        try issueSupportMove(names, &game, "Italy", "Tunis", "Tyrrhenian Sea", "Western Mediterranean Sea");
        try issueMove(names, &game, "Italy", "Tyrrhenian Sea", "Western Mediterranean Sea");

        try game.adjudicateSpring();

        try issueRetreat(names, &game, "France", "Western Mediterranean Sea", "Spain South Coast"); // Illegal

        try game.adjudicateSpringRetreats();
        try game.stepSpring();

        try expectEmptyAtArea(game, names, "Spain");
        try expectUnitAtArea(game, names, "Italy", "Western Mediterranean Sea");
    }
}

// 6.I. TEST CASES, BUILDING

test "6.I.1. TEST CASE, TOO MANY BUILD ORDERS" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.extra_builds = .throw_error;

        try setSCOwner(names, &game, "Germany", "Warsaw");
        try setSCOwner(names, &game, "Germany", "Kiel");
        try setSCOwner(names, &game, "Germany", "Munich");

        try createArmyAt(names, &game, "Germany", "Spain");
        try createArmyAt(names, &game, "Germany", "Portugal");

        game.season = .winter;

        try std.testing.expectError(error.NotHome, issueBuildArmy(names, &game, "Germany", "Warsaw"));
        try issueBuildArmy(names, &game, "Germany", "Kiel");
        try std.testing.expectError(error.ExtraBuild, issueBuildArmy(names, &game, "Germany", "Munich"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.extra_builds = .pick_first;

        try setSCOwner(names, &game, "Germany", "Warsaw");
        try setSCOwner(names, &game, "Germany", "Kiel");
        try setSCOwner(names, &game, "Germany", "Munich");

        try createArmyAt(names, &game, "Germany", "Spain");
        try createArmyAt(names, &game, "Germany", "Portugal");

        game.season = .winter;

        try std.testing.expectError(error.NotHome, issueBuildArmy(names, &game, "Germany", "Warsaw"));
        try issueBuildArmy(names, &game, "Germany", "Kiel");
        try issueBuildArmy(names, &game, "Germany", "Munich");

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectUnitAtArea(game, names, "Germany", "Kiel");
        try expectEmptyAtArea(game, names, "Munich");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.extra_builds = .pick_last;

        try setSCOwner(names, &game, "Germany", "Warsaw");
        try setSCOwner(names, &game, "Germany", "Kiel");
        try setSCOwner(names, &game, "Germany", "Munich");

        try createArmyAt(names, &game, "Germany", "Spain");
        try createArmyAt(names, &game, "Germany", "Portugal");

        game.season = .winter;

        try std.testing.expectError(error.NotHome, issueBuildArmy(names, &game, "Germany", "Warsaw"));
        try issueBuildArmy(names, &game, "Germany", "Kiel");
        try issueBuildArmy(names, &game, "Germany", "Munich");

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectEmptyAtArea(game, names, "Kiel");
        try expectUnitAtArea(game, names, "Germany", "Munich");
    }
}

test "6.I.2. TEST CASE, FLEETS CANNOT BE BUILD IN LAND AREAS" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try setSCOwner(names, &game, "Russia", "Moscow");

    game.season = .winter;

    try std.testing.expectError(error.WrongAreaType, issueBuildFleet(names, &game, "Russia", "Moscow"));
}

test "6.I.3. TEST CASE, SUPPLY CENTER MUST BE EMPTY FOR BUILDING" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try setSCOwner(names, &game, "Germany", "Berlin");
    try setSCOwner(names, &game, "Germany", "Munich");

    try createUnitAt(names, &game, "Germany", "Berlin");

    game.season = .winter;

    try std.testing.expectError(error.BusyArea, issueBuildArmy(names, &game, "Germany", "Berlin"));
}

test "6.I.4. TEST CASE, BOTH COASTS MUST BE EMPTY FOR BUILDING" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try setSCOwner(names, &game, "Russia", "Moscow");
    try setSCOwner(names, &game, "Russia", "St. Petersburg");

    try createFleetAt(names, &game, "Russia", "St. Petersburg South Coast");

    game.season = .winter;

    try std.testing.expectError(error.BusyArea, issueBuildArmy(names, &game, "Russia", "St. Petersburg North Coast"));
}

test "6.I.5. TEST CASE, BUILDING IN HOME SUPPLY CENTER THAT IS NOT OWNED" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try setSCOwner(names, &game, "Russia", "Berlin");
    try setSCOwner(names, &game, "Germany", "Munich");

    try createArmyAt(names, &game, "Russia", "Moscow");

    game.season = .winter;

    try std.testing.expectError(error.NotOwnedHome, issueBuildArmy(names, &game, "Germany", "Berlin"));
}

test "6.I.6. TEST CASE, BUILDING IN OWNED SUPPLY CENTER THAT IS NOT A HOME SUPPLY CENTER" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    try setSCOwner(names, &game, "Germany", "Warsaw");

    game.season = .winter;

    try std.testing.expectError(error.NotHome, issueBuildArmy(names, &game, "Germany", "Warsaw"));
}

test "6.I.7. TEST CASE, ONLY ONE BUILD IN A HOME SUPPLY CENTER" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .throw_error;

        try setSCOwner(names, &game, "Russia", "Moscow");
        try setSCOwner(names, &game, "Russia", "Warsaw");

        game.season = .winter;

        try issueBuildArmy(names, &game, "Russia", "Moscow");
        try std.testing.expectError(error.DuplicateOrder, issueBuildArmy(names, &game, "Russia", "Moscow"));

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectUnitAtArea(game, names, "Russia", "Moscow");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .ignore;

        try setSCOwner(names, &game, "Russia", "Moscow");
        try setSCOwner(names, &game, "Russia", "Warsaw");

        game.season = .winter;

        try issueBuildArmy(names, &game, "Russia", "Moscow");
        try issueBuildArmy(names, &game, "Russia", "Moscow");

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectUnitAtArea(game, names, "Russia", "Moscow");
    }
}

// 6.J. TEST CASES, CIVIL DISORDER AND DISBANDS

test "6.J.1. TEST CASE, TOO MANY DISBAND ORDERS" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.extra_builds = .throw_error;

        try setSCOwner(names, &game, "France", "Paris");

        try createArmyAt(names, &game, "France", "Paris");
        try createArmyAt(names, &game, "France", "Picardy");

        game.season = .winter;

        try std.testing.expectError(error.NoUnit, issueDisband(names, &game, "France", "Gulf of Lyon"));
        try issueDisband(names, &game, "France", "Picardy");
        try std.testing.expectError(error.ExtraBuild, issueDisband(names, &game, "France", "Paris"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.extra_builds = .pick_first;

        try setSCOwner(names, &game, "France", "Paris");

        try createArmyAt(names, &game, "France", "Paris");
        try createArmyAt(names, &game, "France", "Picardy");

        game.season = .winter;

        try std.testing.expectError(error.NoUnit, issueDisband(names, &game, "France", "Gulf of Lyon"));
        try issueDisband(names, &game, "France", "Picardy");
        try issueDisband(names, &game, "France", "Paris");

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectUnitAtArea(game, names, "France", "Paris");
        try expectEmptyAtArea(game, names, "Picardy");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.extra_builds = .pick_last;

        try setSCOwner(names, &game, "France", "Paris");

        try createArmyAt(names, &game, "France", "Paris");
        try createArmyAt(names, &game, "France", "Picardy");

        game.season = .winter;

        try std.testing.expectError(error.NoUnit, issueDisband(names, &game, "France", "Gulf of Lyon"));
        try issueDisband(names, &game, "France", "Picardy");
        try issueDisband(names, &game, "France", "Paris");

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectUnitAtArea(game, names, "France", "Picardy");
        try expectEmptyAtArea(game, names, "Paris");
    }
}

test "6.J.2. TEST CASE, REMOVING THE SAME UNIT TWICE" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .throw_error;

        try createArmyAt(names, &game, "France", "Paris");
        try createArmyAt(names, &game, "France", "Picardy");

        game.season = .winter;

        try issueDisband(names, &game, "France", "Paris");
        try std.testing.expectError(error.DuplicateOrder, issueDisband(names, &game, "France", "Paris"));
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.duplicate_orders = .ignore;
        game.options.missing_orders = .issue_defaults;

        try createArmyAt(names, &game, "France", "Paris");
        try createArmyAt(names, &game, "France", "Picardy");

        game.season = .winter;

        try issueDisband(names, &game, "France", "Paris");
        try issueDisband(names, &game, "France", "Paris");

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectEmptyAtArea(game, names, "Paris");
        try expectEmptyAtArea(game, names, "Picardy");
    }
}

test "6.J.3. TEST CASE, CIVIL DISORDER TWO ARMIES WITH DIFFERENT DISTANCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.missing_orders = .issue_defaults;

    try setSCOwner(names, &game, "Russia", "St. Petersburg");

    try createArmyAt(names, &game, "Russia", "Livonia");
    try createArmyAt(names, &game, "Russia", "Sweden");

    game.season = .winter;

    try game.adjudicateWinter();
    try game.stepWinter();

    try expectUnitAtArea(game, names, "Russia", "Livonia");
    try expectEmptyAtArea(game, names, "Sweden");
}

test "6.J.4. TEST CASE, CIVIL DISORDER TWO ARMIES WITH EQUAL DISTANCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.missing_orders = .issue_defaults;

    try setSCOwner(names, &game, "Russia", "Moscow");

    try createArmyAt(names, &game, "Russia", "Livonia");
    try createArmyAt(names, &game, "Russia", "Ukraine");

    game.season = .winter;

    try game.adjudicateWinter();
    try game.stepWinter();

    try expectUnitAtArea(game, names, "Russia", "Ukraine");
    try expectEmptyAtArea(game, names, "Livonia");
}

test "6.J.5 TEST CASE, CIVIL DISORDER TWO FLEETS WITH DIFFERENT DISTANCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.missing_orders = .issue_defaults;

    try setSCOwner(names, &game, "Russia", "St. Petersburg");

    try createFleetAt(names, &game, "Russia", "Skagerrak");
    try createFleetAt(names, &game, "Russia", "Berlin");

    game.season = .winter;

    try game.adjudicateWinter();
    try game.stepWinter();

    try expectUnitAtArea(game, names, "Russia", "Skagerrak");
    try expectEmptyAtArea(game, names, "Berlin");
}

test "6.J.6. TEST CASE, CIVIL DISORDER TWO FLEETS WITH EQUAL DISTANCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.missing_orders = .issue_defaults;

    try setSCOwner(names, &game, "Russia", "Munich");

    try createFleetAt(names, &game, "Russia", "Gulf of Bothnia");
    try createFleetAt(names, &game, "Russia", "North Sea");

    game.season = .winter;

    try game.adjudicateWinter();
    try game.stepWinter();

    try expectUnitAtArea(game, names, "Russia", "North Sea");
    try expectEmptyAtArea(game, names, "Gulf of Bothnia");
}

test "6.J.7. TEST CASE, CIVIL DISORDER TWO FLEETS AND ARMY WITH EQUAL DISTANCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.missing_orders = .issue_defaults;

    try setSCOwner(names, &game, "Russia", "St. Petersburg");
    try setSCOwner(names, &game, "Russia", "Warsaw");

    try createArmyAt(names, &game, "Russia", "Bohemia");
    try createFleetAt(names, &game, "Russia", "Skagerrak");
    try createFleetAt(names, &game, "Russia", "North Sea");

    game.season = .winter;

    try game.adjudicateWinter();
    try game.stepWinter();

    try expectUnitAtArea(game, names, "Russia", "Bohemia");
    try expectUnitAtArea(game, names, "Russia", "Skagerrak");
    try expectEmptyAtArea(game, names, "North Sea");
}

test "6.J.8. TEST CASE, CIVIL DISORDER A FLEET WITH SHORTER DISTANCE THEN THE ARMY" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.missing_orders = .issue_defaults;

    try setSCOwner(names, &game, "Russia", "Warsaw");

    try createArmyAt(names, &game, "Russia", "Tyrolia");
    try createFleetAt(names, &game, "Russia", "Baltic Sea");

    game.season = .winter;

    try game.adjudicateWinter();
    try game.stepWinter();

    try expectUnitAtArea(game, names, "Russia", "Baltic Sea");
    try expectEmptyAtArea(game, names, "Tyrolia");
}

test "6.J.9. TEST CASE, CIVIL DISORDER MUST BE COUNTED FROM BOTH COASTS" {
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.missing_orders = .issue_defaults;

        try setSCOwner(names, &game, "Russia", "St. Petersburg");
        try setSCOwner(names, &game, "Russia", "Sevastopol");

        try createArmyAt(names, &game, "Russia", "Sevastopol");
        try createArmyAt(names, &game, "Russia", "Greece");
        try createFleetAt(names, &game, "Russia", "Baltic Sea");

        game.season = .winter;

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectUnitAtArea(game, names, "Russia", "Baltic Sea");
        try expectUnitAtArea(game, names, "Russia", "Sevastopol");
        try expectEmptyAtArea(game, names, "Greece");
    }
    {
        var game, var names = try classic.classicGame(std.testing.allocator);
        defer game.deinit(std.testing.allocator);
        defer names.deinit(std.testing.allocator);
        game.clearBoard();

        game.options.missing_orders = .issue_defaults;

        try setSCOwner(names, &game, "Russia", "St. Petersburg");
        try setSCOwner(names, &game, "Russia", "Sevastopol");

        try createArmyAt(names, &game, "Russia", "Sevastopol");
        try createArmyAt(names, &game, "Russia", "Greece");
        try createFleetAt(names, &game, "Russia", "Skagerrak");

        game.season = .winter;

        try game.adjudicateWinter();
        try game.stepWinter();

        try expectUnitAtArea(game, names, "Russia", "Skagerrak");
        try expectUnitAtArea(game, names, "Russia", "Sevastopol");
        try expectEmptyAtArea(game, names, "Greece");
    }
}

test "6.J.10. TEST CASE, CIVIL DISORDER COUNTING CONVOYING DISTANCE" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.missing_orders = .issue_defaults;

    try setSCOwner(names, &game, "Italy", "Naples");

    try createArmyAt(names, &game, "Italy", "Greece");
    try createFleetAt(names, &game, "Italy", "Piedmont");

    game.season = .winter;

    try game.adjudicateWinter();
    try game.stepWinter();

    try expectUnitAtArea(game, names, "Italy", "Greece");
    try expectEmptyAtArea(game, names, "Piedmont");
}

test "6.J.11. TEST CASE, DISTANCE TO OWNED SUPPLY CENTER" {
    var game, var names = try classic.classicGame(std.testing.allocator);
    defer game.deinit(std.testing.allocator);
    defer names.deinit(std.testing.allocator);
    game.clearBoard();

    game.options.missing_orders = .issue_defaults;

    try setSCOwner(names, &game, "Italy", "Warsaw");

    try createArmyAt(names, &game, "Italy", "Warsaw");
    try createFleetAt(names, &game, "Italy", "Tuscany");

    game.season = .winter;

    try game.adjudicateWinter();
    try game.stepWinter();

    try expectUnitAtArea(game, names, "Italy", "Warsaw");
    try expectEmptyAtArea(game, names, "Tuscany");
}
