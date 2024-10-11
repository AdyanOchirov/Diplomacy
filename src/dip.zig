//  Table of Contents
//
//  Basic definitions         -0030
//  Map                       -0217
//  Options                   -0414
//  Game                      -0501
//      Simple utils          -0563
//      Sandbox               -0685
//      Builds                -0750
//          Legality          -0859
//      Disbands              -0906
//          Legality          -0995
//      Retreats              -1043
//          Legality          -1145
//      Commands              -1204
//          Legality          -1335
//      Adjudication          -1475
//          Civil Disorder    -1665
//          Retreat Phase     -1757
//          Move Phase        -1781
//              Utils         -1781
//              Resolution    -1926
//      Legal Iterators       -2286

const std = @import("std");

pub const idint = u16;

//  |---------------------|
//--|  Basic definitions  |
//  |---------------------|

pub const Land = struct {
    id: idint,
    pub fn province(self: Land) Province {
        return .{ .land = self };
    }
};
pub const Water = struct {
    id: idint,
    pub fn province(self: Water) Province {
        return .{ .water = self };
    }
};
pub const Coast = struct {
    id: idint,
    pub fn province(self: Coast) Province {
        return .{ .coast = self };
    }
};

/// Province is a place where a unit can be.
/// `London` and `London Coast` are two different provinces but lie in the same area.
/// Two units cannot occupy the same area.
pub const Province = union(enum) {
    land: Land,
    water: Water,
    coast: Coast,

    /// Returns whether two provinces are for same unit type.
    pub fn compatible(self: Province, other: Province) bool {
        return (self == .land and other == .land) or (self != .land and other != .land);
    }
};

pub const Country = struct { id: idint };

fn IdIterator(comptime T: type) type {
    switch (T) {
        Land, Water, Coast, Country => {},
        else => @compileError("Invalid type"),
    }
    return struct {
        n: idint,
        i: idint = 0,
        pub fn next(self: *@This()) ?T {
            if (self.i < self.n) {
                self.i += 1;
                return T{ .id = self.i - 1 };
            }
            return null;
        }
        pub fn reset(self: *@This()) void {
            self.i = 0;
        }
    };
}
pub const CountryIterator = IdIterator(Country);
pub const LandIterator = IdIterator(Land);
pub const WaterIterator = IdIterator(Water);
pub const CoastIterator = IdIterator(Coast);
pub const ProvinceIterator = struct {
    land_iter: LandIterator,
    water_iter: WaterIterator,
    coast_iter: CoastIterator,

    pub fn next(self: *ProvinceIterator) ?Province {
        if (self.land_iter.next()) |land| {
            return land.province();
        }
        if (self.water_iter.next()) |water| {
            return water.province();
        }
        if (self.coast_iter.next()) |coast| {
            return coast.province();
        }
        return null;
    }
    pub fn reset(self: *ProvinceIterator) void {
        self.land_iter.reset();
        self.water_iter.reset();
        self.coast_iter.reset();
    }
};

pub const SupplyCenter = struct {
    land: Land,
    owner: ?Country,
    home_owner: ?Country,
};

/// Used for intermidiate calculations during adjudication.
/// Orders are created `unresolved` and change to `succeeded` or `failed`.
/// Treatment of `illegal` orders depends on game options.
pub const Status = enum { unresolved, succeeded, failed, illegal };

pub const HoldCommand = struct {};
pub const MoveCommand = struct { to: Province };
pub const ConvoyMoveCommand = struct { to: Province };
pub const ConvoyTransportCommand = struct { from: Province, to: Province };
pub const SupportMoveCommand = struct { from: Province, to: Province };
pub const SupportHoldCommand = struct { at: Province };
pub const Command = union(enum) {
    hold: HoldCommand,
    move: MoveCommand,
    convoy_move: ConvoyMoveCommand,
    convoy_transport: ConvoyTransportCommand,
    support_move: SupportMoveCommand,
    support_hold: SupportHoldCommand,

    /// Returns destination if move command, null otherwise.
    pub fn to(self: Command) ?Province {
        switch (self) {
            .move => |move| return move.to,
            .convoy_move => |convoy| return convoy.to,
            else => return null,
        }
    }

    /// Returns province of another unit, if command implies it.
    pub fn other(self: Command) ?Province {
        switch (self) {
            .support_move => |sm| return sm.from,
            .support_hold => |sh| return sh.at,
            .convoy_transport => |ct| return ct.from,
            else => return null,
        }
    }

    /// Returns destination of another unit, if command implies it.
    pub fn otherTo(self: Command) ?Province {
        switch (self) {
            .support_move => |sm| return sm.to,
            .support_hold => |sh| return sh.at,
            .convoy_transport => |ct| return ct.to,
            else => return null,
        }
    }
};

/// Unit type is inferred from `province` type.
pub const Unit = struct {
    country: Country,
    province: Province,
    command: ?Command = null,
    status: Status = .unresolved,
};

/// `to == null` means disband. `status` signals survival of the unit. So disbands are always adjudicated `failed`.
pub const Retreat = struct {
    unit_idx: idint,
    to: ?Province,
    status: Status = .unresolved,
};

pub const GameSeason = enum {
    spring,
    spring_retreat,
    spring_end,
    fall,
    fall_retreat,
    fall_end,
    winter,
    winter_end,

    pub fn isMove(self: GameSeason) bool {
        return (self == .spring) or (self == .fall);
    }
    pub fn isRetreat(self: GameSeason) bool {
        return (self == .spring_retreat) or (self == .fall_retreat);
    }
    pub fn isBuild(self: GameSeason) bool {
        return (self == .winter);
    }
    pub fn isSpring(self: GameSeason) bool {
        return (self == .spring) or (self == .spring_retreat) or (self == .spring_end);
    }
    pub fn isFall(self: GameSeason) bool {
        return (self == .fall) or (self == .fall_retreat) or (self == .fall_end);
    }
    pub fn isWinter(self: GameSeason) bool {
        return (self == .winter) or (self == .winter_end);
    }
};

//  |-------|
//--|  Map  |
//  |-------|

// Maybe separate neighbours to land-land, coast-water, water-water.
// Maybe duplicate entries to (a,b) and (b,a). Then sort them.
// This way we don't need to iterate over all pairs for neighbour iteration and `border` function.

/// Holds all geographical information about provinces.
pub const Map = struct {
    pub const Pair = struct { Province, Province };

    /// Holds all adjacencies between provinces.
    pairs: []Pair,

    /// Allows coast=>owner lookup using `coast.id`.
    coast_owners: []Land,

    /// Every land and water sorted in reverse-alphabetical order for civil disorder adjudication.
    sorted_areas: []Province,

    n_lands: idint,
    n_waters: idint,
    n_coasts: idint,

    pub fn initEmpty(allocator: std.mem.Allocator, n_lands: idint, n_waters: idint, n_coasts: idint, n_pairs: idint) std.mem.Allocator.Error!Map {
        const n_areas = n_lands + n_waters;

        const pairs = try allocator.alloc(Pair, n_pairs);
        const coast_owners = try allocator.alloc(Land, n_coasts);
        const sorted_areas = try allocator.alloc(Province, n_areas);
        return Map{
            .pairs = pairs,
            .coast_owners = coast_owners,
            .sorted_areas = sorted_areas,
            .n_lands = n_lands,
            .n_waters = n_waters,
            .n_coasts = n_coasts,
        };
    }

    pub fn deinit(self: *Map, allocator: std.mem.Allocator) void {
        allocator.free(self.coast_owners);
        allocator.free(self.pairs);
        allocator.free(self.sorted_areas);
        self.* = undefined;
    }

    /// Iterates through coasts owned by the given land. Returns them as provinces.
    pub const OwnedCoastIterator = struct {
        land: Land,
        coast_owners: []const Land,
        i: idint = 0,

        pub fn next(self: *OwnedCoastIterator) ?Province {
            while (self.i < self.coast_owners.len) {
                defer self.i += 1;
                if (std.meta.eql(self.coast_owners[self.i], self.land)) return .{ .coast = .{ .id = self.i } };
            }
            return null;
        }
    };

    /// Iterates through neighbours of the given province.
    pub const NeighbourIterator = struct {
        province: Province,
        pairs: []const Pair,
        i: idint = 0,

        pub fn next(self: *NeighbourIterator) ?Province {
            while (self.i < self.pairs.len) {
                defer self.i += 1;
                if (std.meta.eql(self.pairs[self.i][0], self.province)) return self.pairs[self.i][1];
                if (std.meta.eql(self.pairs[self.i][1], self.province)) return self.pairs[self.i][0];
            }
            return null;
        }
    };

    /// Reterns whether two provinces share a border.
    pub fn border(self: Map, x: Province, y: Province) bool {
        for (self.pairs) |pair| {
            if (std.meta.eql(pair[0], x) and std.meta.eql(pair[1], y)) return true;
            if (std.meta.eql(pair[0], y) and std.meta.eql(pair[1], x)) return true;
        }
        return false;
    }

    /// Returns land or water containing the given province.
    pub fn areaOf(self: Map, x: Province) Province {
        switch (x) {
            .land => return x,
            .water => return x,
            .coast => return self.ownerOf(x.coast).province(),
        }
    }

    /// Returns whether two provinces are part of the same area.
    pub fn sameArea(self: Map, x: Province, y: Province) bool {
        return std.meta.eql(self.areaOf(x), self.areaOf(y));
    }

    /// Returns land that owns the given coast.
    pub fn ownerOf(self: Map, x: Coast) Land {
        return self.coast_owners[x.id];
    }

    /// Returns an iterator over the coasts owned by the given land.
    pub fn ownedCoastIterator(self: Map, x: Land) OwnedCoastIterator {
        return .{ .land = x, .coast_owners = self.coast_owners };
    }

    /// Returns an iterator over the neighbours of the given province.
    pub fn neighbourIterator(self: Map, x: Province) NeighbourIterator {
        return .{ .province = x, .pairs = self.pairs };
    }

    pub const WrongAreaType = error{WrongAreaType};

    /// Returns province from same area compatible with army.
    pub fn adaptForArmy(self: Map, x: Province) WrongAreaType!Province {
        switch (x) {
            .land => return x,
            .water => return error.WrongAreaType,
            .coast => return self.ownerOf(x.coast).province(),
        }
    }

    pub const AdaptFleetError = WrongAreaType || error{CantInferCoast};

    /// Returns province from same area compatible with fleet if unique.
    pub fn adaptForFleet(self: Map, x: Province) AdaptFleetError!Province {
        switch (x) {
            .land => {
                var coast_iter = self.ownedCoastIterator(x.land);
                var ans: ?Province = null;
                while (coast_iter.next()) |coast| {
                    if (ans != null) return error.CantInferCoast;
                    ans = coast;
                }
                if (ans) |ret| return ret else return error.WrongAreaType;
            },
            .water => return x,
            .coast => return x,
        }
    }

    pub const AdaptTargetError = AdaptFleetError;

    /// Returns province from same area as `to` compatible with `unit_province` and bordering it if possible.
    /// If already compatible, does nothing.
    pub fn adaptTarget(self: Map, unit_province: Province, to: Province) AdaptTargetError!Province {
        if (unit_province == .land) {
            return self.adaptForArmy(to);
        } else {
            switch (to) {
                .land => return self.adaptLandTargetForFleet(unit_province, to.land),
                .coast, .water => return to,
            }
        }
    }

    /// Returns province from same area as `to` compatible with `unit_province` and bordering it if possible.
    /// Can change from coast to coast.
    pub fn adaptTargetAggresive(self: Map, unit_province: Province, to: Province) AdaptTargetError!Province {
        if (unit_province == .land) {
            return self.adaptForArmy(to);
        } else {
            switch (to) {
                .land => return self.adaptLandTargetForFleet(unit_province, to.land),
                .coast => |coast| {
                    if (self.border(unit_province, to)) return to;
                    return self.adaptLandTargetForFleet(unit_province, self.ownerOf(coast));
                },
                .water => return to,
            }
        }
    }

    /// Returns the land's coast that borders the given province if unique.
    fn adaptLandTargetForFleet(self: Map, fleet_province: Province, x: Land) AdaptFleetError!Province {
        var coast_iter = self.ownedCoastIterator(x);
        var ans: ?Province = null;
        var backup: ?Province = null;
        var n_coasts: idint = 0;
        while (coast_iter.next()) |coast| {
            if (self.border(fleet_province, coast)) {
                if (ans != null) return error.CantInferCoast;
                ans = coast;
            }
            backup = coast;
            n_coasts += 1;
        }
        return ans orelse if (n_coasts == 1) backup.? else error.WrongAreaType;
    }
};

//  |-----------|
//--|  Options  |
//  |-----------|

pub const GameOptions = struct {
    /// How to deal with missing orders.
    missing_orders: MissingOrdersPolicy = .throw_error,

    /// How to deal with illegal orders during move phase.
    illegal_commands: IllegalCommandsPolicy = .throw_error,

    /// How to deal with illegal orders during retreat phase.
    illegal_retreats: IllegarRetreatsPolicy = .throw_error,

    /// How to treat repeated orders to same unit/province.
    duplicate_orders: DuplicateOrdersPolicy = .throw_error,

    /// How to handle more build/disband orders than possible.
    extra_builds: ExtraBuildsPolicy = .throw_error,

    /// How to adapt land<->coast provinces in orders. All changes are within one area.
    adapt_area: AdaptAreaPolicy = .adapt,

    /// When to substitute move for move via convoy.
    move_to_convoy: MoveToConvoyPolicy = .never,

    /// Whether to substitute X - X in moves and supports into X holds and support holds.
    move_to_self_is_hold: bool = false,

    /// Whether to convert legal move to move via convoy if there is a legal transport order from same power.
    infer_convoy_intent: bool = false,

    /// Whether convoy move can use land route when convoy is cancelled.
    convoy_can_fallback: bool = false,
};

pub const MissingOrdersPolicy = enum {
    throw_error,
    issue_defaults,
};

pub const IllegalCommandsPolicy = enum {
    throw_error,
    convert_to_hold,
    treat_as_hold,
    treat_stationary_as_hold,
};

pub const IllegarRetreatsPolicy = enum {
    throw_error,
    convert_to_disband,
    treat_as_disband,
};

pub const DuplicateOrdersPolicy = enum {
    throw_error,
    ignore,
    overwrite,
};

pub const AdaptAreaPolicy = enum {
    /// Orders are not preprocessed.
    ignore,
    /// F Mar - Spa is coerced into F Mar(coast) - Spa(sc)
    adapt,
    /// F Mar - Spa(nc) is coerced into F Mar(coast) - Spa(sc)
    adapt_across_coasts,
};

pub const ExtraBuildsPolicy = enum {
    throw_error,
    pick_first,
    pick_last,
};

pub const MoveToConvoyPolicy = enum {
    never,
    illegal_to_legal,
    always,
};

pub const WrongPhase = error{WrongPhase};
pub const WrongCountry = error{WrongCountry};
pub const NoUnit = error{NoUnit};
pub const NoOrder = error{NoOrder};
pub const DuplicateOrder = error{DuplicateOrder};

//  |--------|
//--|  Game  |
//  |--------|

/// Everything required to play a game of Diplomacy.
pub const Game = struct {
    /// Intended to be set once before game start. But some options probably can be changed at any moment.
    options: GameOptions = .{},
    map: Map,
    supply_centers: []SupplyCenter,
    units: std.ArrayListUnmanaged(Unit),
    /// All builds are guaranteed to be possibl. Country is inferred from sc at province.
    builds: std.ArrayListUnmanaged(Province),
    /// Holds indices of units to be disbanded. All disbands are guaranteed to be possible.
    disbands: std.ArrayListUnmanaged(idint),
    retreats: std.ArrayListUnmanaged(Retreat),

    season: GameSeason = .spring,
    n_countries: idint,

    /// Used to store temporary data about areas.
    area_buf: []idint,

    pub fn initEmpty(
        allocator: std.mem.Allocator,
        n_countries: idint,
        n_lands: idint,
        n_waters: idint,
        n_coasts: idint,
        n_sc: idint,
        n_pairs: idint,
    ) std.mem.Allocator.Error!Game {
        const map = try Map.initEmpty(allocator, n_lands, n_waters, n_coasts, n_pairs);
        const supply_centers = try allocator.alloc(SupplyCenter, n_sc);
        const units = try std.ArrayListUnmanaged(Unit).initCapacity(allocator, n_sc);
        const builds = try std.ArrayListUnmanaged(Province).initCapacity(allocator, n_sc);
        const disband_idxs = try std.ArrayListUnmanaged(idint).initCapacity(allocator, n_sc);
        const retreats = try std.ArrayListUnmanaged(Retreat).initCapacity(allocator, n_sc);
        const area_buf = try allocator.alloc(idint, n_lands + n_waters);
        return Game{
            .map = map,
            .n_countries = n_countries,
            .supply_centers = supply_centers,
            .units = units,
            .builds = builds,
            .disbands = disband_idxs,
            .retreats = retreats,
            .area_buf = area_buf,
        };
    }

    pub fn deinit(self: *Game, allocator: std.mem.Allocator) void {
        self.map.deinit(allocator);
        allocator.free(self.supply_centers);
        self.units.deinit(allocator);
        self.builds.deinit(allocator);
        self.disbands.deinit(allocator);
        self.retreats.deinit(allocator);
        allocator.free(self.area_buf);
        self.* = undefined;
    }

    //  |----------------|
    //--|  Simple utils  |
    //  |----------------|

    pub fn countryIterator(self: Game) CountryIterator {
        return .{ .n = self.n_countries };
    }

    pub fn coastIterator(self: Game) CoastIterator {
        return .{ .n = self.map.n_coasts };
    }

    pub fn landIterator(self: Game) LandIterator {
        return .{ .n = self.map.n_lands };
    }

    pub fn waterIterator(self: Game) WaterIterator {
        return .{ .n = self.map.n_waters };
    }

    pub fn provinceIterator(self: Game) ProvinceIterator {
        return .{
            .land_iter = self.landIterator(),
            .water_iter = self.waterIterator(),
            .coast_iter = self.coastIterator(),
        };
    }

    pub fn scAt(self: Game, province: Province) ?SupplyCenter {
        if (province == .water) return null;
        const land = self.map.areaOf(province).land;
        for (self.supply_centers) |sc| if (std.meta.eql(sc.land, land)) return sc;
        return null;
    }

    pub fn unitIdxAtProvince(self: Game, province: Province) ?idint {
        for (self.units.items, 0..) |unit, i| if (std.meta.eql(unit.province, province)) return @intCast(i);
        return null;
    }

    pub fn unitIdxAtArea(self: Game, province: Province) ?idint {
        for (self.units.items, 0..) |unit, i| if (self.map.sameArea(unit.province, province)) return @intCast(i);
        return null;
    }

    /// Returns index of a unit in the given province or its area depending on `adapt_area` option.
    pub fn unitIdxAt(self: Game, province: Province) ?idint {
        if (self.options.adapt_area != .ignore) return self.unitIdxAtArea(province) else return self.unitIdxAtProvince(province);
    }

    pub fn retreatIdxOf(self: Game, unit_idx: idint) ?idint {
        for (self.retreats.items, 0..) |retreat, i| if (std.meta.eql(retreat.unit_idx, unit_idx)) return @intCast(i);
        return null;
    }

    pub fn retreatIdxAt(self: Game, province: Province) ?idint {
        const unit_idx = self.unitIdxAt(province) orelse return null;
        return self.retreatIdxOf(unit_idx);
    }

    pub fn buildIdxAt(self: Game, province: Province) ?idint {
        for (self.builds.items, 0..) |build, i| if (self.map.sameArea(build, province)) return @intCast(i);
        return null;
    }

    pub fn buildOwner(self: Game, build_idx: idint) Country {
        return self.scAt(self.builds.items[build_idx]).?.home_owner.?;
    }

    pub fn disbandIdxOf(self: Game, unit_idx: idint) ?idint {
        for (self.disbands.items, 0..) |disband, i| if (disband == unit_idx) return @intCast(i);
        return null;
    }

    pub fn disbandIdxAt(self: Game, province: Province) ?idint {
        const unit_idx = self.unitIdxAt(province) orelse return null;
        return self.disbandIdxOf(unit_idx);
    }

    pub fn unitCount(self: Game, country: Country) idint {
        var count: idint = 0;
        for (self.units.items) |unit| {
            if (std.meta.eql(country, unit.country)) count += 1;
        }
        return count;
    }

    pub fn scCount(self: Game, country: Country) idint {
        var count: idint = 0;
        for (self.supply_centers) |sc| {
            if (std.meta.eql(sc.owner, country)) count += 1;
        }
        return count;
    }

    pub fn buildCount(self: Game, country: Country) idint {
        var count: idint = 0;
        for (self.builds.items) |build| {
            const sc = self.scAt(build).?;
            if (std.meta.eql(sc.home_owner, country)) count += 1;
        }
        return count;
    }

    pub fn disbandCount(self: Game, country: Country) idint {
        var count: idint = 0;
        for (self.disbands.items) |unit_idx| {
            const unit = self.units.items[unit_idx];
            if (std.meta.eql(unit.country, country)) count += 1;
        }
        return count;
    }

    /// Returns province from same area as `to`. Depends on `adapt_area` option.
    pub fn adaptTarget(self: Game, province: Province, to: Province) Map.AdaptTargetError!Province {
        switch (self.options.adapt_area) {
            .adapt => return try self.map.adaptTarget(province, to),
            .adapt_across_coasts => return try self.map.adaptTargetAggresive(province, to),
            .ignore => return to,
        }
    }

    //  |--------------|
    //--|  Sandboxing  |
    //  |--------------|

    /// Removes all units and sets SCs as neutral. Does not remove home status. Useful for testing.
    pub fn clearBoard(self: *Game) void {
        self.units.items.len = 0;
        self.builds.items.len = 0;
        for (self.supply_centers) |*sc| {
            sc.*.owner = null;
        }
    }

    pub const NoSC = error{NoSC};

    /// If country is not specified, makes SC neutral. Does not change home status.
    pub fn setSCOwner(self: Game, country_mb: ?Country, land: Land) NoSC!void {
        for (self.supply_centers) |*sc| {
            if (std.meta.eql(sc.land, land)) {
                sc.owner = country_mb;
                return;
            }
        }
        return error.NoSC;
    }

    pub const CreateUnitError = error{ BusyArea, AtCapacity } || WrongPhase;

    pub fn createUnitAt(self: *Game, country: Country, province: Province) CreateUnitError!void {
        if (!self.season.isMove() and !self.season.isBuild()) return error.WrongPhase;
        if (self.unitIdxAtArea(province) != null) return error.BusyArea;
        if (self.units.items.len == self.supply_centers.len) return error.AtCapacity;
        self.units.appendAssumeCapacity(.{ .country = country, .province = province });
    }

    pub const CreateArmyError = CreateUnitError || Map.WrongAreaType;

    pub fn createArmyAt(self: *Game, country: Country, province: Province) CreateArmyError!void {
        if (!self.season.isMove() and !self.season.isBuild()) return error.WrongPhase;
        if (self.unitIdxAtArea(province) != null) return error.BusyArea;
        if (self.units.items.len == self.supply_centers.len) return error.AtCapacity;
        if (self.options.adapt_area == .ignore and province != .land) return error.WrongAreaType;
        const area = try self.map.adaptForArmy(province);
        self.units.appendAssumeCapacity(.{ .country = country, .province = area });
    }

    pub const CreateFleetError = CreateUnitError || Map.AdaptFleetError;

    pub fn createFleetAt(self: *Game, country: Country, province: Province) CreateFleetError!void {
        if (!self.season.isMove() and !self.season.isBuild()) return error.WrongPhase;
        if (self.unitIdxAtArea(province) != null) return error.BusyArea;
        if (self.units.items.len == self.supply_centers.len) return error.AtCapacity;
        if (self.options.adapt_area == .ignore and province == .land) return error.WrongAreaType;
        const area = try self.map.adaptForFleet(province);
        self.units.appendAssumeCapacity(.{ .country = country, .province = area });
    }

    pub const RemoveUnitError = NoUnit || WrongPhase;

    pub fn removeUnitAt(self: *Game, province: Province) RemoveUnitError!void {
        if (!self.season.isMove() and !self.season.isBuild()) return error.WrongPhase;
        const unit_idx = self.unitIdxAt(province) orelse return error.NoUnit;
        _ = self.units.swapRemove(unit_idx);
    }

    //  |----------|
    //--|  Builds  |
    //  |----------|

    pub const IssueBuildArmyError = IssueBuildError || Map.WrongAreaType;

    /// See `issueBuild`.
    pub fn issueBuildArmy(self: *Game, country_mb: ?Country, province: Province) IssueBuildArmyError!void {
        if (!self.season.isWinter()) return error.WrongPhase;
        const area = try self.map.adaptForArmy(province);
        try self.issueBuild(country_mb, area);
    }

    pub const IssueBuildFleetError = IssueBuildError || Map.AdaptFleetError;

    /// See `issueBuild`.
    pub fn issueBuildFleet(self: *Game, country_mb: ?Country, province: Province) IssueBuildFleetError!void {
        if (!self.season.isWinter()) return error.WrongPhase;
        const area = try self.map.adaptForFleet(province);
        try self.issueBuild(country_mb, area);
    }

    pub const ExtraBuildError = error{ExtraBuild};
    pub const IssueBuildError = WrongPhase || IllegalBuildError || DuplicateOrder || ExtraBuildError;

    /// Behaviour depends on `duplicate_orders` and `extra_builds` options.
    /// If error is returned, it specifies the reason build was rejected.
    /// Nothing being returned does not guarantee that the build was accepted.
    /// Impossible builds are always rejected.
    ///
    /// If country is specified, makes sure that the supply center is owned by that country.
    pub fn issueBuild(self: *Game, country_mb: ?Country, province: Province) IssueBuildError!void {
        try self.validateBuildLegality(country_mb, province);
        if (try self.handleDuplicateBuild(province)) return; // Order
        if (try self.handleExtraBuild(province)) return; // Matters
        self.builds.appendAssumeCapacity(province);
    }

    /// If the province already has a build, handles issuing it and returns error or true, depending on options.
    /// Otherwise returns false.
    fn handleDuplicateBuild(self: *Game, province: Province) DuplicateOrder!bool {
        for (self.builds.items, 0..) |other, i| if (self.map.sameArea(other, province)) switch (self.options.duplicate_orders) {
            .throw_error => return error.DuplicateOrder,
            .ignore => return true,
            .overwrite => {
                _ = self.builds.orderedRemove(i);
                self.builds.appendAssumeCapacity(province);
                return true;
            },
        };
        return false;
    }

    /// If the country cannot build more units, handles issuing the build and returns error or true, depending on options.
    /// Otherwise returns false.
    fn handleExtraBuild(self: *Game, province: Province) ExtraBuildError!bool {
        const country = self.scAt(province).?.home_owner.?;
        if (self.buildsLeft(country) catch unreachable == 0) switch (self.options.extra_builds) {
            .throw_error => return error.ExtraBuild,
            .pick_first => return true,
            .pick_last => {
                for (self.builds.items, 0..) |other, i| {
                    const other_sc = self.scAt(other).?;
                    if (!std.meta.eql(other_sc.home_owner.?, country)) continue;
                    _ = self.builds.orderedRemove(i);
                    self.builds.appendAssumeCapacity(province);
                    return true;
                }
            },
        };
        return false;
    }

    pub const ResetBuildError = WrongPhase || WrongCountry || NoOrder;

    /// If province is specified, removes build order for that area. If not, removes all builds.
    /// If country is specified, only that country's build orders are affected.
    pub fn resetBuildAt(self: *Game, country_mb: ?Country, province_mb: ?Province) ResetBuildError!void {
        // `orderedRemove` because order matters for `extra_builds` setting.
        if (!self.season.isWinter()) return error.WrongPhase;
        if (country_mb) |country| if (!(self.canBuildPhase(country) catch unreachable)) return error.NoOrder;
        if (province_mb) |province| {
            for (self.builds.items, 0..) |build, i| {
                if (self.map.sameArea(build, province)) {
                    if (country_mb) |c| {
                        const sc = self.scAt(build).?;
                        if (!std.meta.eql(c, sc.home_owner.?)) return error.WrongCountry;
                    }
                    _ = self.builds.orderedRemove(i);
                    return;
                }
            }
            return error.NoOrder;
        } else {
            var i: idint = 0;
            while (i < self.builds.items.len) {
                const build = self.builds.items[i];
                if (country_mb) |c| {
                    const sc = self.scAt(build).?;
                    if (!std.meta.eql(c, sc.home_owner.?)) {
                        i += 1;
                        continue;
                    }
                }
                _ = self.builds.orderedRemove(i);
            }
        }
    }

    //  |-------------------|
    //--|  Builds Legality  |
    //  |-------------------|

    pub const IllegalBuildError = WrongPhase || error{ NotHome, NotOwnedHome, BusyArea, NoSC, DontNeed };

    /// If build is legal returns nothing, otherwise returns error specifying the problem.
    /// If country is specified, makes sure that supply center is owned by that country.
    /// Does not take into account previously issued builds.
    pub fn validateBuildLegality(self: *const Game, country_mb: ?Country, province: Province) IllegalBuildError!void {
        if (!self.season.isWinter()) return error.WrongPhase;
        const sc = self.scAt(province) orelse return error.NoSC;
        const home_owner = sc.home_owner orelse return error.NotHome;
        const owner = sc.owner orelse return error.NotOwnedHome; // Home centers can never be neutral in normal game. But can be made in sandbox.
        if (country_mb) |country| {
            if (!std.meta.eql(country, home_owner)) return error.NotHome;
            if (!std.meta.eql(country, owner)) return error.NotOwnedHome;
        } else {
            if (!std.meta.eql(home_owner, owner)) return error.NotOwnedHome;
        }
        const country = if (country_mb) |country| country else home_owner;
        if (!(self.canBuildPhase(country) catch unreachable)) return error.DontNeed;
        if (self.unitIdxAtArea(province) != null) return error.BusyArea;
    }

    /// Wrapper around `validateBuildLegality` that maps error/void to false/true.
    pub fn isLegalBuild(self: Game, country_mb: ?Country, province: Province) WrongPhase!bool {
        self.validateBuildLegality(country_mb, province) catch |err| switch (err) {
            error.WrongPhase => return error.WrongPhase,
            else => return false,
        };
        return true;
    }

    /// Whether the country can issue build orders this winter.
    pub fn canBuildPhase(self: Game, country: Country) WrongPhase!bool {
        if (!self.season.isWinter()) return error.WrongPhase;
        return self.unitCount(country) < self.scCount(country);
    }

    /// Returns amount of unused build orders.
    pub fn buildsLeft(self: Game, country: Country) WrongPhase!idint {
        if (!self.season.isWinter()) return error.WrongPhase;
        if (!(self.canBuildPhase(country) catch unreachable)) return 0;
        return self.scCount(country) - self.unitCount(country) - self.buildCount(country);
    }

    //  |------------|
    //--|  Disbands  |
    //  |------------|

    pub const IssueDisbandAtError = IssueDisbandError || NoUnit;

    /// See `issueDisband`.
    pub fn issueDisbandAt(self: *Game, country_mb: ?Country, province: Province) IssueDisbandAtError!void {
        const unit_idx = self.unitIdxAt(province) orelse return error.NoUnit;
        try self.issueDisband(country_mb, unit_idx);
    }

    pub const IssueDisbandError = IllegalDisbandError || DuplicateOrder || ExtraBuildError;

    /// Behaviour depends on `duplicate_orders` and `extra_builds` options.
    /// If error is returned, it specifies the reason disband was rejected.
    /// Nothing being returned does not guarantee that the disband was accepted.
    /// Impossible disbands always rejected.
    ///
    /// If country is specified, makes sure that the unit is owned by that country.
    pub fn issueDisband(self: *Game, country_mb: ?Country, unit_idx: idint) IssueDisbandError!void {
        try validateDisbandLegality(self, country_mb, unit_idx);
        if (try self.handleDuplicateDisband(unit_idx)) return; // Order
        if (try self.handleExtraDisband(unit_idx)) return; // Matters
        self.disbands.appendAssumeCapacity(unit_idx);
    }

    /// If the unit is already being disbanded, handles issuing the disband and returns error or true, depending on options.
    /// Otherwise returns false.
    fn handleDuplicateDisband(self: *Game, unit_idx: idint) DuplicateOrder!bool {
        for (self.disbands.items, 0..) |other_idx, i| if (other_idx == unit_idx) switch (self.options.duplicate_orders) {
            .throw_error => return error.DuplicateOrder,
            .ignore => return true,
            .overwrite => {
                self.disbands.appendAssumeCapacity(self.disbands.orderedRemove(i));
                return true;
            },
        };
        return false;
    }

    /// If the country cannot disband more units, handles issuing the disband and returns error or true, depending on options.
    /// Otherwise returns false.
    fn handleExtraDisband(self: *Game, unit_idx: idint) ExtraBuildError!bool {
        const country = self.units.items[unit_idx].country;
        if (self.disbandsLeft(country) catch unreachable == 0) switch (self.options.extra_builds) {
            .throw_error => return error.ExtraBuild,
            .pick_first => return true,
            .pick_last => {
                for (self.disbands.items, 0..) |other_idx, i| {
                    const other = self.units.items[other_idx];
                    if (!std.meta.eql(other.country, country)) continue;
                    _ = self.disbands.orderedRemove(i);
                    self.disbands.appendAssumeCapacity(unit_idx);
                    return true;
                }
            },
        };
        return false;
    }

    /// If province is specified, removes disband order for that province. If not, removes all disbands.
    /// If country is specified, only that country's disband orders are affected.
    pub fn resetDisbandAt(self: *Game, country_mb: ?Country, province_mb: ?Province) ResetBuildError!void {
        if (!self.season.isWinter()) return error.WrongPhase;
        if (country_mb) |country| if (!(self.shouldDisbandPhase(country) catch unreachable)) return error.NoOrder;
        if (province_mb) |province| {
            for (self.disbands.items, 0..) |unit_idx, i| {
                const unit = self.units.items[unit_idx];
                if (self.map.sameArea(unit.province, province)) {
                    if (country_mb) |country| if (!std.meta.eql(country, unit.country)) return error.WrongCountry;
                    _ = self.disbands.orderedRemove(i);
                    return;
                }
            }
            return error.NoOrder;
        } else {
            var i: idint = 0;
            while (i < self.disbands.items.len) {
                const unit = self.units.items[self.disbands.items[i]];
                if (country_mb) |country| if (!std.meta.eql(country, unit.country)) {
                    i += 1;
                    continue;
                };
                _ = self.disbands.orderedRemove(i);
            }
        }
    }

    //  |---------------------|
    //--|  Disbands Legality  |
    //  |---------------------|

    pub fn allDisbandsIssued(self: Game) WrongPhase!bool {
        if (!self.season.isWinter()) return error.WrongPhase;
        var countries_iter = self.countryIterator();
        while (countries_iter.next()) |country| {
            if (self.disbandsLeft(country) > 0) return false;
        }
        return true;
    }

    pub const IllegalDisbandError = WrongPhase || WrongCountry || error{DontNeed};

    /// If disband is legal returns nothing, otherwise returns error specifying the problem.
    /// If country is specified, makes sure that the unit is owned by that country.
    /// Does not take into account previously issued disbands.
    pub fn validateDisbandLegality(self: *const Game, country_mb: ?Country, unit_idx: idint) IllegalDisbandError!void {
        if (!self.season.isWinter()) return error.WrongPhase;
        const unit = self.units.items[unit_idx];
        const country = country_mb orelse unit.country;
        if (!std.meta.eql(unit.country, country)) return error.WrongCountry;
        if (!(self.shouldDisbandPhase(country) catch unreachable)) return error.DontNeed;
    }

    /// Wrapper around `validateDisbandLegality` that maps error/void to false/true.
    pub fn isLegalDisband(self: Game, country_mb: ?Country, unit_idx: idint) WrongPhase!bool {
        self.validateDisbandLegality(country_mb, unit_idx) catch |err| switch (err) {
            error.WrongPhase => return error.WrongPhase,
            else => return false,
        };
        return true;
    }

    /// Whether the country should issue disband orders this winter.
    pub fn shouldDisbandPhase(self: Game, country: Country) WrongPhase!bool {
        if (!self.season.isWinter()) return error.WrongPhase;
        return self.unitCount(country) > self.scCount(country);
    }

    /// Returns amount of unused disband orders.
    pub fn disbandsLeft(self: Game, country: Country) WrongPhase!idint {
        if (!self.season.isWinter()) return error.WrongPhase;
        if (!(self.shouldDisbandPhase(country) catch unreachable)) return 0;
        return self.unitCount(country) - self.scCount(country) - self.disbandCount(country);
    }

    //  |------------|
    //--|  Retreats  |
    //  |------------|

    pub const IssueRetreatAtError = IssueRetreatError || NoUnit;

    /// See `issueRetreat`.
    pub fn issueRetreatAt(self: *Game, country_mb: ?Country, province: Province, to: ?Province) IssueRetreatAtError!void {
        const unit_idx = self.unitIdxAt(province) orelse if (self.options.illegal_retreats == .throw_error) return error.NoUnit else return;
        try self.issueRetreat(country_mb, unit_idx, to);
    }

    pub const IssueRetreatError = WrongPhase || WrongCountry || DuplicateOrder || IllegalRetreatError || Map.AdaptTargetError;

    /// Behaviour depends on `adapt_area`, `duplicate_orders` and `illegal_retreats` options.
    /// If error is returned, it specifies the reason retreat was rejected.
    /// Nothing being returned does not guarantee that the retreat was accepted.
    ///
    /// If country is specified, makes sure that the unit is owned by that country.
    /// If target is not specified, issues disband.
    pub fn issueRetreat(self: *Game, country_mb: ?Country, unit_idx: idint, to: ?Province) IssueRetreatError!void {
        if (!self.season.isRetreat()) return error.WrongPhase;
        if (country_mb) |country| if (!std.meta.eql(country, self.units.items[unit_idx].country)) if (self.options.illegal_retreats == .throw_error) return error.WrongCountry else return;
        const adapted_to = self.adaptRetreatTarget(unit_idx, to) catch |err| if (self.options.illegal_retreats == .throw_error) return err else to;
        if (try self.handleDuplicateRetreat(unit_idx, adapted_to)) return; // Order
        if (try self.handleIlllegalRetreat(unit_idx, adapted_to)) return; // Matters
        self.retreats.appendAssumeCapacity(Retreat{ .unit_idx = unit_idx, .to = to });
    }

    fn addRetreat(self: *Game, retreat: Retreat) void {
        for (self.retreats.items) |*other| {
            if (retreat.unit_idx == other.unit_idx) {
                other.to = retreat.to;
                other.status = retreat.status;
                return;
            }
        }
        self.retreats.appendAssumeCapacity(retreat);
    }

    /// Modifies a retreat target depending on options. All changes to the province are within its area.
    /// If error is returned, retreat is guaranteed to be illegal.
    fn adaptRetreatTarget(self: Game, unit_idx: idint, to: ?Province) IssueRetreatError!?Province {
        if (to == null) return null;
        const unit = self.units.items[unit_idx];
        const target = try self.adaptTarget(unit.province, to.?);
        return target;
    }

    /// If a retreat is a duplicate, handles issuing it and returns error or true, depending on options.
    /// Otherwise returns false.
    fn handleDuplicateRetreat(self: *Game, unit_idx: idint, to: ?Province) IssueRetreatError!bool {
        for (self.retreats.items) |*other| if (other.unit_idx == unit_idx) switch (self.options.duplicate_orders) {
            .throw_error => return error.DuplicateOrder,
            .ignore => return true,
            .overwrite => {
                if (try self.handleIlllegalRetreat(unit_idx, to)) return true;
                other.to = to;
                other.status = .unresolved;
                return true;
            },
        };
        return false;
    }

    /// If a retreat is illegal, handles issuing it and returns error or true, depending on options.
    /// Otherwise returns false.
    fn handleIlllegalRetreat(self: *Game, unit_idx: idint, to: ?Province) IssueRetreatError!bool {
        self.validateRetreatLegality(null, unit_idx, to) catch |err| switch (self.options.illegal_retreats) {
            .throw_error => return err,
            .treat_as_disband, .convert_to_disband => {
                if (err == error.NotDislodged) return true;
                const illegal_retreat = Retreat{ .unit_idx = unit_idx, .to = to, .status = .illegal };
                self.addRetreat(illegal_retreat);
                return true;
            },
        };
        return false;
    }

    /// If province is specified, removes retreat order for unit at that province. If not, removes all retreats.
    /// If country is specified, only that country's units are affected.
    pub fn resetRetreatAt(self: *Game, country_mb: ?Country, province_mb: ?Province) ResetOrderError!void {
        if (!self.season.isRetreat()) return error.WrongPhase;
        if (province_mb) |province| {
            const unit_idx = self.unitIdxAt(province) orelse return error.NoUnit;
            const unit = self.units.items[unit_idx];
            if (country_mb) |country| if (!std.meta.eql(country, unit.country)) return error.WrongCountry;
            const retreat_idx = self.retreatIdxOf(unit_idx) orelse return;
            _ = self.retreats.swapRemove(retreat_idx);
        } else {
            for (self.units.items, 0..) |unit, idx| {
                if (country_mb) |country| if (!std.meta.eql(country, unit.country)) continue;
                var i: idint = 0;
                while (i < self.retreats.items.len) {
                    const retreat = self.retreats.items[i];
                    if (retreat.unit_idx == idx) _ = self.retreats.swapRemove(i) else i += 1;
                }
            }
        }
    }

    //  |---------------------|
    //--|  Retreats Legality  |
    //  |---------------------|

    pub fn shouldRetreat(self: Game, unit_idx: idint) WrongPhase!bool {
        if (!self.season.isRetreat()) return error.WrongPhase;
        return self.notDislodgedStatus(unit_idx) == .failed;
    }

    pub fn allRetreatsIssued(self: Game) WrongPhase!bool {
        if (!self.season.isRetreat()) return error.WrongPhase;
        for (self.units.items, 0..) |_, i| {
            const unit_idx: idint = @intCast(i);
            if (self.notDislodgedStatus(unit_idx) == .failed and self.retreatIdxOf(unit_idx) == null) return false;
        }
        return true;
    }

    pub const IllegalRetreatError = WrongPhase || WrongCountry || error{ NotDislodged, NoBorder, BusyArea, HeadToHead };

    /// If retreat is illegal returns error specifying the problem.
    /// If country is specified, makes sure that unit is owned by that country.
    pub fn validateRetreatLegality(self: Game, country_mb: ?Country, unit_idx: idint, to: ?Province) IllegalRetreatError!void {
        if (!self.season.isRetreat()) return error.WrongPhase;
        const unit = self.units.items[unit_idx];
        if (country_mb) |country| if (!std.meta.eql(country, unit.country)) return error.WrongCountry;
        if (self.notDislodgedStatus(unit_idx) == .succeeded) return error.NotDislodged;
        const target = to orelse return;
        if (!self.map.border(unit.province, target)) return error.NoBorder;
        if (self.unitIdxAtArea(target)) |other_idx| {
            const other = self.units.items[other_idx];
            switch (other.command.?) {
                .move, .convoy_move => {
                    if (other.status == .failed) return error.BusyArea;
                    if (self.map.sameArea(unit.province, other.command.?.to().?))
                        if (self.landPathStatus(other_idx) == .succeeded) return error.HeadToHead;
                },
                else => return error.BusyArea,
            }
        }
        var move_iter = self.areaMoveIterator(target);
        while (move_iter.next()) |other_idx| {
            if (self.pathStatus(other_idx) == .failed) continue;
            if (self.h2hAgainst(other_idx)) |other_h2h_idx| {
                const other_h2h = self.units.items[other_h2h_idx];
                if (other_h2h.status == .succeeded) continue;
            } else return error.BusyArea;
        }
    }

    /// Wrapper around `validateRetreatLegality` that maps error/void to false/true.
    pub fn isLegalRetreat(self: Game, country_mb: ?Country, unit_idx: idint, to: ?Province) WrongPhase!bool {
        self.validateRetreatLegality(country_mb, unit_idx, to) catch |err| switch (err) {
            error.WrongPhase => return error.WrongPhase,
            else => return false,
        };
        return true;
    }

    //  |------------|
    //--|  Commands  |
    //  |------------|

    pub const IssueCommandAtError = IssueCommandError || NoUnit;

    /// See `issueCommand`.
    pub fn issueCommandAt(self: *Game, country_mb: ?Country, province: Province, command: Command) IssueCommandAtError!void {
        const unit_idx = self.unitIdxAt(province) orelse if (self.options.illegal_commands == .throw_error) return error.NoUnit else return;
        try self.issueCommand(country_mb, unit_idx, command);
    }

    pub const IssueCommandError = WrongPhase || WrongCountry || DuplicateOrder || IllegalCommandError || Map.AdaptTargetError;

    /// Behaviour depends on `adapt_area`, `duplicate_orders` and `illegal_commands` options.
    /// If error is returned, it specifies the reason command was rejected.
    /// Nothing being returned does not guarantee that the command was accepted.
    ///
    /// If country is specified, makes sure that the unit is owned by that country.
    pub fn issueCommand(self: *Game, country_mb: ?Country, unit_idx: idint, command: Command) IssueCommandError!void {
        if (!self.season.isMove()) return error.WrongPhase;
        const unit = &self.units.items[unit_idx];
        if (country_mb) |country| if (!std.meta.eql(country, unit.country)) if (self.options.illegal_commands == .throw_error) return error.WrongCountry else return;
        const adapted_command = self.adaptCommand(unit_idx, command) catch |err| if (self.options.illegal_commands == .throw_error) return err else command;
        if (try handleDuplicateCommand(self, unit_idx, adapted_command)) return; // Order
        if (try handleIllegalCommand(self, unit_idx, adapted_command)) return; // Matters
        unit.command = adapted_command;
        unit.status = .unresolved;
    }

    /// If the unit already has a command, handles issuing it and returns error or true, depending on options.
    /// Otherwise returns false.
    fn handleDuplicateCommand(self: *Game, unit_idx: idint, command: Command) IssueCommandError!bool {
        const unit = &self.units.items[unit_idx];
        if (unit.command != null) {
            switch (self.options.duplicate_orders) {
                .throw_error => return error.DuplicateOrder,
                .ignore => return true,
                .overwrite => {
                    if (try self.handleIllegalCommand(unit_idx, command)) return true;
                    unit.command = command;
                    unit.status = .unresolved;
                    return true;
                },
            }
        }
        return false;
    }

    /// If a command is illegal, handles issuing it and returns error or true, depending on options.
    /// Otherwise returns false.
    fn handleIllegalCommand(self: *Game, unit_idx: idint, command: Command) IssueCommandError!bool {
        const unit = &self.units.items[unit_idx];
        self.validateCommandLegality(null, unit_idx, command) catch |err| {
            switch (self.options.illegal_commands) {
                .throw_error => return err,
                .treat_as_hold, .treat_stationary_as_hold, .convert_to_hold => {
                    unit.*.command = command;
                    unit.status = .illegal;
                    return true;
                },
            }
        };
        return false;
    }

    /// Modifies a command depending on options and board state. All changes to provinces are within their area.
    /// If error is returned, command is guaranteed to be illegal.
    fn adaptCommand(self: Game, unit_idx: idint, command: Command) IssueCommandError!Command {
        const unit = self.units.items[unit_idx];
        switch (command) {
            .hold => return command,
            .move => |m| {
                if (self.map.sameArea(unit.province, m.to) and self.options.move_to_self_is_hold) return .{ .hold = .{} };
                const to = try self.adaptTarget(unit.province, m.to);
                if (self.options.move_to_convoy == .always and unit.province == .land) return .{ .convoy_move = .{ .to = to } };
                if (self.options.move_to_convoy == .illegal_to_legal)
                    if (!(self.isLegalCommand(null, unit_idx, .{ .move = .{ .to = to } }) catch unreachable))
                        if (self.isLegalCommand(null, unit_idx, .{ .convoy_move = .{ .to = to } }) catch unreachable)
                            return .{ .convoy_move = .{ .to = to } };
                return .{ .move = .{ .to = to } };
            },
            .convoy_move => |convoy_move| {
                if (self.map.sameArea(unit.province, convoy_move.to) and self.options.move_to_self_is_hold) return .{ .hold = .{} };
                const to = try self.adaptTarget(unit.province, convoy_move.to);
                return .{ .convoy_move = .{ .to = to } };
            },
            .convoy_transport => |transport| {
                if (self.unitIdxAt(transport.from)) |transported_idx| {
                    const transported = self.units.items[transported_idx];
                    const to = try self.adaptTarget(transported.province, transport.to);
                    return .{ .convoy_transport = .{ .from = transported.province, .to = to } };
                } else return error.NoOtherUnit;
            },
            .support_move => |support| {
                if (self.unitIdxAt(support.from)) |supported_idx| {
                    const supported = self.units.items[supported_idx];
                    const to = try self.adaptTarget(supported.province, support.to);
                    if (self.map.sameArea(supported.province, support.to) and self.options.move_to_self_is_hold)
                        return .{ .support_hold = .{ .at = supported.province } };
                    return .{ .support_move = .{ .from = supported.province, .to = to } };
                } else return error.NoOtherUnit;
            },
            .support_hold => |support_hold| {
                if (self.unitIdxAt(support_hold.at)) |supported_idx| {
                    const supported = self.units.items[supported_idx];
                    return .{ .support_hold = .{ .at = supported.province } };
                } else return error.NoOtherUnit;
            },
        }
    }

    pub const ResetOrderError = WrongPhase || WrongCountry || NoUnit;

    /// If province is specified, removes command for unit at that province. If not, removes all commands.
    /// If country is specified, only that country's units are affected.
    pub fn resetCommandAt(self: *Game, country_mb: ?Country, province_mb: ?Province) ResetOrderError!void {
        if (!self.season.isMove()) return error.WrongPhase;
        if (province_mb) |province| {
            const unit_idx = self.unitIdxAt(province) orelse return error.NoUnit;
            const unit = &self.units.items[unit_idx];
            if (country_mb) |country| if (!std.meta.eql(country, unit.country)) return error.WrongCountry;
            unit.command = null;
        } else {
            for (self.units.items) |*unit| {
                if (country_mb) |country| if (!std.meta.eql(country, unit.country)) continue;
                unit.command = null;
            }
        }
    }

    //  |---------------------|
    //--|  Commands Legality  |
    //  |---------------------|

    pub fn allCommandsIssued(self: Game) WrongPhase!bool {
        if (!self.season.isMove()) return error.WrongPhase;
        for (self.units.items) |unit| {
            if (unit.command == null) return false;
        }
        return true;
    }

    pub const IllegalCommandError = WrongPhase || WrongCountry || error{ NoPath, NoOtherUnit, TransportNoPath, SupportNoPath, CantSupport, WrongType, WrongAreaType };

    /// If the command is illegal, returns error specifying the problem.
    /// If country is specified, makes sure that unit is owned by that country.
    pub fn validateCommandLegality(self: Game, country_mb: ?Country, unit_idx: idint, command: Command) IllegalCommandError!void {
        if (!self.season.isMove()) return error.WrongPhase;
        const unit = self.units.items[unit_idx];
        if (country_mb) |country| if (!std.meta.eql(country, unit.country)) return error.WrongCountry;
        const province = unit.province;
        switch (command) {
            .hold => return,
            .move => |m| {
                if (!province.compatible(m.to)) return error.WrongAreaType;
                if (!self.map.border(province, m.to)) return error.NoPath;
            },
            .convoy_move => |cm| {
                if (province != .land) return error.WrongType;
                if (!province.compatible(cm.to)) return error.WrongAreaType;
                if (self.options.convoy_can_fallback and self.map.border(province, cm.to)) return;
                self.setBufForConvoy();
                if (!self.hasConvoyPathBuf(province, cm.to, null)) return error.NoPath;
            },
            .convoy_transport => |t| {
                if (province != .water or t.from != .land) return error.WrongType;
                if (t.to != .land) return error.WrongAreaType;
                if (self.unitIdxAtProvince(t.from) == null) return error.NoOtherUnit;
                self.setBufForConvoy();
                if (!self.hasConvoyPathBuf(t.from, t.to, province)) return error.TransportNoPath;
            },
            .support_move => |s| {
                if (!s.from.compatible(s.to)) return error.WrongAreaType;
                if (self.unitIdxAtProvince(s.from) == null) return error.SupportNoPath;
                if (!self.canSupportTo(province, s.to)) return error.CantSupport;
                // Check if can support as move.
                if (self.map.border(s.to, s.from)) return;
                // Check if we can support as convoy move.
                self.setBufForConvoy();
                if (province == .water) self.area_buf[province.water.id] = 2;
                if (self.hasConvoyPathBuf(s.from, s.to, null)) return;
                return error.SupportNoPath;
            },
            .support_hold => |support_hold| {
                if (self.unitIdxAtProvince(support_hold.at) == null) return error.NoOtherUnit;
                if (!self.canSupportTo(province, support_hold.at)) return error.CantSupport;
            },
        }
    }

    /// Wrapper around `validateCommandLegality` that maps error/void to false/true.
    pub fn isLegalCommand(self: Game, country_mb: ?Country, unit_idx: idint, command: Command) WrongPhase!bool {
        self.validateCommandLegality(country_mb, unit_idx, command) catch |err| switch (err) {
            error.WrongPhase => return error.WrongPhase,
            else => return false,
        };
        return true;
    }

    /// Checks if a unit at `province` can support to `to`
    fn canSupportTo(self: Game, province: Province, to: Province) bool {
        var neighbours_iter = self.map.neighbourIterator(province);
        while (neighbours_iter.next()) |neighbour| {
            if (self.map.sameArea(neighbour, to)) return true;
        }
        return false;
    }

    /// Checks if there is a convoy path between two provinces, optionally going through given water province.
    /// Available waters must be marked with 0. The chosen path will be marked with 1 afterwards.
    fn hasConvoyPathBuf(self: Game, x: Province, y: Province, through_mb: ?Province) bool {
        if (x != .land or y != .land) return false;
        if (self.map.sameArea(x, y)) return false;
        const through_water: ?Water = if (through_mb) |through| blk: {
            if (through != .water) return false;
            break :blk through.water;
        } else null;

        var x_coasts_iter = self.map.ownedCoastIterator(x.land);
        while (x_coasts_iter.next()) |x_coast| {
            var y_coasts_iter = self.map.ownedCoastIterator(y.land);
            while (y_coasts_iter.next()) |y_coast| {
                var x_neighbours_iter = self.map.neighbourIterator(x_coast);
                while (x_neighbours_iter.next()) |x_neighbour| {
                    if (x_neighbour != .water) continue;
                    var y_neighbours_iter = self.map.neighbourIterator(y_coast);
                    while (y_neighbours_iter.next()) |y_neighbour| {
                        if (y_neighbour != .water) continue;
                        if (self.waterIsConnectedBuf(x_neighbour.water, y_neighbour.water, through_water)) return true;
                    }
                }
            }
        }
        return false;
    }

    /// Recursively checks whether there is a path through waters marked 0 using, optionally going through given water.
    /// Marks the taken path with 1.
    fn waterIsConnectedBuf(self: Game, x: Water, y: Water, through_mb: ?Water) bool {
        // Recursively go from x to its water neighbours while marking current path.
        // Upon path completition check if `through_mb` is in the path.
        // If so, return true, otherwise continue search.
        if (self.area_buf[x.id] != 0 or self.area_buf[y.id] != 0) return false;
        if (std.meta.eql(x, y)) {
            self.area_buf[x.id] = 1;
            if (through_mb) |through| {
                if (self.area_buf[through.id] == 1) return true;
            } else return true;
            self.area_buf[x.id] = 0;
            return false;
        }

        self.area_buf[x.id] = 1;
        var x_neighbours = self.map.neighbourIterator(x.province());
        while (x_neighbours.next()) |x_neighbour| {
            if (x_neighbour != .water) continue;
            if (self.waterIsConnectedBuf(x_neighbour.water, y, through_mb)) return true;
        }
        self.area_buf[x.id] = 0;
        return false;
    }

    /// Marks all fleets as available for transport.
    fn setBufForConvoy(self: Game) void {
        @memset(self.area_buf, 2);
        for (self.units.items) |unit| {
            if (unit.province == .water) self.area_buf[unit.province.water.id] = 0;
        }
    }

    //  |----------------|
    //--|  Adjudication  |
    //  |----------------|

    pub const AdjudicationError = WrongPhase || NoOrder;

    /// Sets statuses of `unresolved` units to `succeeded` or `failed`.
    /// Transitions the game to spring retreats.
    pub fn adjudicateSpring(self: *Game) AdjudicationError!void {
        if (self.season != .spring) return error.WrongPhase;
        try self.handleMissingCommands();
        self.adjudicateMovePhase();
        self.season = .spring_retreat;
    }

    /// Sets statuses of `unresolved` retreats to `succeeded` or `failed`.
    /// Transitions the game to spring end.
    pub fn adjudicateSpringRetreats(self: *Game) AdjudicationError!void {
        if (self.season != .spring_retreat) return error.WrongPhase;
        try self.handleMissingRetreats();
        self.adjudicateRetreatPhase();
        self.season = .spring_end;
    }

    /// Adjust units based on adjudication results and deletes all information about spring orders.
    /// Transitions the game to fall.
    pub fn stepSpring(self: *Game) WrongPhase!void {
        if (self.season != .spring_end) return error.WrongPhase;
        self.adjustUnits();
        self.clearCommands();
        self.clearRetreats();
        self.season = .fall;
    }

    /// Sets statuses of `unresolved` units to `succeeded` or `failed`.
    /// Transitions the game to fall retreats.
    pub fn adjudicateFall(self: *Game) AdjudicationError!void {
        if (self.season != .fall) return error.WrongPhase;
        try self.handleMissingCommands();
        self.adjudicateMovePhase();
        self.season = .fall_retreat;
    }

    /// Sets statuses of `unresolved` retreats to `succeeded` or `failed`.
    /// Transitions the game to fall end.
    pub fn adjudicateFallRetreats(self: *Game) AdjudicationError!void {
        if (self.season != .fall_retreat) return error.WrongPhase;
        try self.handleMissingRetreats();
        self.adjudicateRetreatPhase();
        self.season = .fall_end;
    }

    /// Adjust units and supply centers based on adjudication results and deletes all information about fall orders.
    /// Transitions the game to winter.
    pub fn stepFall(self: *Game) WrongPhase!void {
        if (self.season != .fall_end) return error.WrongPhase;
        self.adjustUnits();
        self.adjustSCs();
        self.clearCommands();
        self.clearRetreats();
        self.season = .winter;
    }

    /// Stops ability to order new builds and disbands.
    /// Transitions the game to winter end.
    pub fn adjudicateWinter(self: *Game) AdjudicationError!void {
        if (!self.season.isWinter()) return error.WrongPhase;
        try self.handleMissingDisbands();
        self.season = .winter_end;
    }

    /// Adds and removes units based on orders and deletes all information about winter orders.
    /// Transitions the game to spring.
    pub fn stepWinter(self: *Game) WrongPhase!void {
        if (!self.season.isWinter()) return error.WrongPhase;
        self.applyBuilds();
        self.clearBuilds();
        self.season = .spring;
    }

    fn clearCommands(self: Game) void {
        for (self.units.items) |*unit| {
            unit.command = null;
            unit.status = .unresolved;
        }
    }

    fn clearBuilds(self: *Game) void {
        self.builds.items.len = 0;
        self.disbands.items.len = 0;
    }

    fn clearRetreats(self: *Game) void {
        self.retreats.items.len = 0;
    }

    /// If a unit is missing command, throws error or sets it to hold, depending on options.
    fn handleMissingCommands(self: Game) NoOrder!void {
        for (self.units.items) |*unit| {
            if (unit.command == null) {
                if (self.options.missing_orders == .throw_error) {
                    return error.NoOrder;
                } else {
                    unit.command = .{ .hold = .{} };
                }
            }
        }
    }

    /// If dislodged unit is missing retreat, throws error or sets it to disband, depending on options.
    fn handleMissingRetreats(self: *Game) NoOrder!void {
        for (self.units.items, 0..) |_, i| if (self.notDislodgedStatus(@intCast(i)) == .failed) {
            if (self.retreatIdxOf(@intCast(i)) == null) {
                if (self.options.missing_orders == .throw_error) {
                    return error.NoOrder;
                } else {
                    self.retreats.appendAssumeCapacity(.{ .unit_idx = @intCast(i), .to = null });
                }
            }
        };
    }

    /// If a country is missing disband, throws error or applies civil disorder, depending on options.
    fn handleMissingDisbands(self: *Game) NoOrder!void {
        var country_iter = self.countryIterator();
        while (country_iter.next()) |country| {
            if (self.disbandsLeft(country) catch unreachable == 0) continue;
            if (self.options.missing_orders == .throw_error) return error.NoOrder;
            self.applyCivilDisorder(country);
        }
    }

    /// Removes units disbanded in retreat phase, updates positions of moved units.
    fn adjustUnits(self: *Game) void {
        // Command must not be null post-adjudication. So we use it as a flag.
        for (self.retreats.items) |retreat| {
            if (self.units.items[retreat.unit_idx].command == null) unreachable;
            switch (retreat.status) {
                .illegal, .failed => self.units.items[retreat.unit_idx].command = null,
                .succeeded => self.units.items[retreat.unit_idx].province = retreat.to.?,
                .unresolved => unreachable,
            }
        }
        var i: idint = 0;
        while (i < self.units.items.len) {
            const unit = &self.units.items[i];
            if (unit.command == null) {
                _ = self.units.swapRemove(i);
                continue;
            }
            if (unit.command.?.to()) |to| {
                if (unit.status == .succeeded) unit.province = to;
            }
            i += 1;
        }
    }

    /// Sets supply centers' owners based on units' positions.
    fn adjustSCs(self: Game) void {
        for (self.supply_centers) |*sc| {
            if (self.unitIdxAtArea(sc.land.province())) |unit_idx| {
                const unit = self.units.items[unit_idx];
                sc.*.owner = unit.country;
            }
        }
    }

    /// Adds and removes units based on orders.
    fn applyBuilds(self: *Game) void {
        // Apply build orders
        for (self.builds.items) |province| {
            const sc = self.scAt(province).?;
            const unit = Unit{ .country = sc.owner.?, .province = province };
            self.units.appendAssumeCapacity(unit);
        }
        // Apply disband orders
        for (self.disbands.items) |unit_idx| {
            // In winter all statuses must be .unresolved, so we use it as a flag.
            if (self.units.items[unit_idx].status == .illegal) unreachable;
            self.units.items[unit_idx].status = .illegal;
        }
        var i: idint = 0;
        while (i < self.units.items.len) {
            const unit = self.units.items[i];
            if (unit.status == .illegal) {
                _ = self.units.swapRemove(i);
            } else i += 1;
        }
    }

    //  |------------------|
    //--|  Civil Disorder  |
    //  |------------------|

    /// Orders missing disbands for country.
    /// Units further from country's supply centers are disbanded first.
    /// If distance is equal, fleets are disbanded first.
    /// If unit types are the same, ones on areas first in alphabetical order are disbanded first
    fn applyCivilDisorder(self: *Game, country: Country) void {
        // We go through units in order specified below.
        // Once we skip enough units, we start issuing disbands for the remaining ones.
        // 1) Look at the areas equidistant from the supply centers. Start at supply centers.
        // 2) Go through armies in reverse alphabetical order.
        // 3) Go through fleets in reverse alphabetical order.
        // 4) Look at areas with one more distance from supply centers. Jump to 2.
        @memset(self.area_buf, 0);
        // 0 in the buffer means unexplored area, anything else is 1 + distance from supply center.
        for (self.supply_centers) |sc| {
            if (!std.meta.eql(sc.owner, country)) continue;
            const area_idx = for (self.map.sorted_areas, 0..) |area, i| {
                if (std.meta.eql(area, sc.land.province())) break i;
            } else unreachable;
            self.area_buf[area_idx] = 1;
        }
        var to_skip = self.scCount(country);
        var cur_dist: idint = 1;
        while (true) {
            // Try Army
            self.cdTryDisband(country, cur_dist, &to_skip, false);
            // Try Fleet
            self.cdTryDisband(country, cur_dist, &to_skip, true);
            // Check.
            // `cdDisbandRest` only works on unexplored areas, so we must finish looking for armies and fleets in explored ones.
            if (to_skip == 0) return self.cdDisbandRest(country);
            // Expand
            for (self.area_buf, 0..) |dist, i| if (dist == cur_dist) {
                const province = self.map.sorted_areas[i];
                self.cdExpandNeighbourBuffer(province, cur_dist);
                const land = if (province == .land) province.land else continue;
                var coast_iter = self.map.ownedCoastIterator(land);
                while (coast_iter.next()) |coast| {
                    self.cdExpandNeighbourBuffer(coast, cur_dist);
                }
            };
            cur_dist += 1;
        }
    }

    /// Issues disbands for all units in unexplorder areas.
    fn cdDisbandRest(self: *Game, country: Country) void {
        outer: for (self.area_buf, 0..) |dist, i| {
            if (dist != 0) continue;
            const area = self.map.sorted_areas[i];
            const unit_idx = self.unitIdxAtArea(area) orelse continue;
            const unit = self.units.items[unit_idx];
            if (!std.meta.eql(unit.country, country)) continue;
            for (self.disbands.items) |other_idx| if (other_idx == unit_idx) break :outer;
            self.disbands.appendAssumeCapacity(unit_idx);
        }
    }

    /// Goes through armies or fleets on areas labeled `cur_dist` in reverse alphabetical order.
    /// Once enough units are skipped, starts issuing disbands.
    fn cdTryDisband(self: *Game, country: Country, cur_dist: idint, to_skip: *idint, fleet: bool) void {
        outer: for (self.area_buf, 0..) |dist, i| if (dist == cur_dist) {
            const province = self.map.sorted_areas[i];
            const unit_idx = self.unitIdxAtArea(province) orelse continue;
            const unit = self.units.items[unit_idx];
            if (fleet and unit.province == .land) continue;
            if (!fleet and unit.province != .land) continue;
            if (!std.meta.eql(unit.country, country)) continue;
            for (self.disbands.items) |other_idx| if (other_idx == unit_idx) break :outer;
            if (to_skip.* == 0) {
                self.disbands.appendAssumeCapacity(unit_idx);
                if (self.disbandsLeft(country) catch unreachable == 0) return;
            } else to_skip.* -= 1;
        };
    }

    /// Sets all unexplored neighbours of `province` to `cur_dist` + 1.
    fn cdExpandNeighbourBuffer(self: *Game, province: Province, cur_dist: idint) void {
        var neighbour_iter = self.map.neighbourIterator(province);
        while (neighbour_iter.next()) |neighbour| {
            const neighbour_area = self.map.areaOf(neighbour);
            const neighbour_idx = for (self.map.sorted_areas, 0..) |area, i| {
                if (std.meta.eql(area, neighbour_area)) break i;
            } else unreachable;
            if (self.area_buf[neighbour_idx] != 0) continue;
            self.area_buf[neighbour_idx] = cur_dist + 1;
        }
    }

    //  |-----------------|
    //--|  Retreat Phase  |
    //  |-----------------|

    /// Sets statuses of `unresolved` retreats to `succeeded` or `failed`.
    fn adjudicateRetreatPhase(self: Game) void {
        for (self.retreats.items, 0..) |*retreat, i| {
            if (self.options.illegal_retreats == .convert_to_disband and retreat.status == .illegal) {
                retreat.to = null;
            }
            if (retreat.to == null or retreat.status == .illegal) {
                continue;
            }
            for (self.retreats.items[i + 1 ..]) |*other| {
                if (other.to == null or other.status == .illegal) continue;
                if (self.map.sameArea(retreat.to.?, other.to.?)) {
                    other.status = .failed;
                    retreat.status = .failed;
                }
            }
            if (retreat.status == .unresolved) retreat.status = .succeeded;
        }
    }

    //  |--------------|
    //--|  Move Phase  |
    //  |--------------|

    /// Used for decisions based on partial information
    const Strength = struct {
        min: u8,
        max: u8,

        fn inc(self: *Strength) void {
            self.min += 1;
            self.max += 1;
        }

        fn incMax(self: *Strength) void {
            self.max += 1;
        }

        fn beats(self: Strength, other: Strength) Status {
            if (self.min > other.max) return .succeeded;
            if (self.max <= other.min) return .failed;
            return .unresolved;
        }

        /// If some strength beats all individual strengths, it will beat its mix.
        /// If some strength loses to at least one individual strength, it will lose to its mix.
        fn mix(self: Strength, other: Strength) Strength {
            const new_min = @max(self.min, other.min);
            const new_max = @max(self.max, other.max);
            return .{ .min = new_min, .max = new_max };
        }
    };

    /// Iterates through all units with the given legal command, potentially ignoring one country.
    /// Used for finding matching supports and convoy transports.
    const CommandIterator = struct {
        units: []Unit,
        command: Command,
        ignore_country_mb: ?Country = null,
        unit_idx: idint = 0,

        pub fn next(self: *CommandIterator) ?idint {
            while (self.unit_idx < self.units.len) {
                defer self.unit_idx += 1;
                const unit = self.units[self.unit_idx];
                if (unit.status == .illegal) continue;
                if (std.meta.eql(unit.command, self.command)) {
                    if (self.ignore_country_mb) |ignore_country| if (std.meta.eql(ignore_country, unit.country)) continue;
                    return self.unit_idx;
                }
            }
            return null;
        }
    };

    /// Iterates over all units legally moving to an area of given province.
    const AreaMoveIterator = struct {
        units: []Unit,
        to: Province,
        map: Map,
        unit_idx: idint = 0,

        pub fn next(self: *AreaMoveIterator) ?idint {
            while (self.unit_idx < self.units.len) {
                defer self.unit_idx += 1;
                const unit = self.units[self.unit_idx];
                if (unit.status == .illegal) continue;
                if (unit.command.?.to()) |target| {
                    if (self.map.sameArea(target, self.to)) return self.unit_idx;
                }
            }
            return null;
        }
    };

    /// Returns an iterator over all units legally moving to an area of given province.
    fn areaMoveIterator(self: Game, to: Province) AreaMoveIterator {
        return .{ .units = self.units.items, .to = to, .map = self.map };
    }

    /// Returns an iterator over all units supporting move/hold of a given unit. Potentially ignores one country.
    fn supportIterator(self: Game, unit_idx: idint, ignore_country_mb: ?Country) CommandIterator {
        const unit = self.units.items[unit_idx];
        if (unit.command.?.to()) |target| {
            if (unit.status != .illegal) {
                return .{
                    .units = self.units.items,
                    .command = .{ .support_move = .{ .from = unit.province, .to = target } },
                    .ignore_country_mb = ignore_country_mb,
                };
            } else if (self.options.illegal_commands == .treat_stationary_as_hold) unreachable;
        }
        return .{
            .units = self.units.items,
            .command = .{ .support_hold = .{ .at = unit.province } },
            .ignore_country_mb = ignore_country_mb,
        };
    }

    /// Returns an iterator over all units supporting move/hold of a given unit.
    fn supportIteratorAny(self: Game, unit_idx: idint) CommandIterator {
        return supportIterator(self, unit_idx, null);
    }

    /// Returns an iterator over all units convoying a given unit.
    fn convoyIterator(self: Game, unit_idx: idint) CommandIterator {
        const unit = self.units.items[unit_idx];
        return CommandIterator{
            .units = self.units.items,
            .command = .{ .convoy_transport = .{ .from = unit.province, .to = unit.command.?.to().? } },
        };
    }

    /// Only produces output if `convoy_can_fallback` is true.
    /// Returns a unit that due to fallbacks can be in head to head battle with the given unit, but isn't at current point of adjudication.
    fn h2hCandidateAgainst(self: Game, unit_idx: idint) ?idint {
        if (!self.options.convoy_can_fallback) return null;
        const unit = self.units.items[unit_idx];
        const target = unit.command.?.to().?;
        if (self.landPathStatus(unit_idx) == .failed) return null;
        if (self.unitIdxAtArea(target)) |target_unit_idx| {
            const target_unit = self.units.items[target_unit_idx];
            if (target_unit.status == .illegal) return null;
            const target_to = target_unit.command.?.to() orelse return null;
            if (self.landPathStatus(target_unit_idx) == .failed) return null;
            if (self.map.sameArea(unit.province, target_to)) return target_unit_idx;
        }
        return null;
    }

    /// Returns a unit that is in head to head battle with the given unit.
    fn h2hAgainst(self: Game, unit_idx: idint) ?idint {
        const unit = self.units.items[unit_idx];
        const target = unit.command.?.to().?;
        if (self.landPathStatus(unit_idx) != .succeeded) return null;
        if (self.unitIdxAtArea(target)) |target_unit_idx| {
            const target_unit = self.units.items[target_unit_idx];
            if (target_unit.status == .illegal) return null;
            const target_to = target_unit.command.?.to() orelse return null;
            if (self.landPathStatus(target_unit_idx) != .succeeded) return null;
            if (self.map.sameArea(unit.province, target_to)) return target_unit_idx;
        }
        return null;
    }

    //  |-------------------|
    //--|  Move Resolution  | Draws heavely from https://diplom.org/Zine/S2009M/Kruijswijk/DipMath_Chp1.htm
    //  |-------------------|

    /// Sets statuses of `unresolved` units to `succeeded` or `failed`.
    /// May do some preprocessing depending on options.
    fn adjudicateMovePhase(self: Game) void {
        if (self.options.illegal_commands == .convert_to_hold) self.convertIllegalToHold();
        if (self.options.infer_convoy_intent) self.inferConvoyIntent();
        self.resolveWhilePossible();
        self.resolveConvoyParadox();
        self.resolveCircularMovement();
    }

    /// Sets all illegal commands to unresolved holds.
    fn convertIllegalToHold(self: Game) void {
        for (self.units.items) |*unit| {
            if (unit.status != .illegal) continue;
            unit.command = .{ .hold = .{} };
            unit.status = .unresolved;
        }
    }

    // Convert a move to convoy if there is legal transport order from same power.
    fn inferConvoyIntent(self: Game) void {
        for (self.units.items, 0..) |*unit, i| {
            if (unit.command.? != .move) continue;
            var convoy_iter = self.convoyIterator(@intCast(i));
            while (convoy_iter.next()) |convoy_idx| {
                const convoy = self.units.items[convoy_idx];
                if (std.meta.eql(convoy.country, unit.country)) {
                    unit.command = .{ .convoy_move = .{ .to = unit.command.?.move.to } };
                    break;
                }
            }
        }
    }

    /// Tries to resolve every unresolved unit. Returns once unable to continue.
    fn resolveWhilePossible(self: Game) void {
        while (true) {
            var changed = false;
            for (self.units.items, 0..) |*unit, idx| {
                if (unit.status != .unresolved) continue;
                const new_status = self.getResolution(@intCast(idx));
                if (new_status == .unresolved) continue;
                unit.status = new_status;
                changed = true;
            }
            if (!changed) break;
        }
    }

    /// Sets all transports as failed and continues to resolve while possible.
    fn resolveConvoyParadox(self: Game) void {
        for (self.units.items) |*unit| {
            if (unit.command.? == .convoy_transport and unit.status == .unresolved) {
                unit.status = .failed;
            }
        }
        self.resolveWhilePossible();
    }

    /// Makes all unresolved orders succeessfull.
    fn resolveCircularMovement(self: Game) void {
        for (self.units.items) |*unit| {
            if (unit.status == .unresolved) unit.status = .succeeded;
        }
    }

    /// Returns what the status of the unit should be given the current information.
    fn getResolution(self: Game, unit_idx: idint) Status {
        const unit = self.units.items[unit_idx];
        switch (unit.command.?) {
            .move => |move| {
                const attack_strength = self.attackStrengthOf(unit_idx);
                const hold_strength = self.holdStrengthAt(move.to);
                const prevent_strength = self.combinedPreventStrengthAgainst(unit_idx);
                const defend_strength = self.getDefendStrengthAgainst(unit_idx);

                const against_strength = hold_strength.mix(prevent_strength).mix(defend_strength);
                return attack_strength.beats(against_strength);
            },
            .convoy_move => |convoy_move| {
                const attack_strength = self.attackStrengthOf(unit_idx);
                const hold_strength = self.holdStrengthAt(convoy_move.to);
                const prevent_strength = self.combinedPreventStrengthAgainst(unit_idx);
                const defend_strength = if (self.options.convoy_can_fallback) self.getDefendStrengthAgainst(unit_idx) else Strength{ .min = 0, .max = 0 };

                const against_strength = hold_strength.mix(prevent_strength).mix(defend_strength);
                return attack_strength.beats(against_strength);
            },
            .convoy_transport => {
                return self.notDislodgedStatus(unit_idx);
            },
            .support_move => {
                return self.notCutStatus(unit_idx);
            },
            .support_hold => {
                return self.notCutStatus(unit_idx);
            },
            .hold => {
                return self.notDislodgedStatus(unit_idx);
            },
        }
    }

    fn attackStrengthOf(self: Game, unit_idx: idint) Strength {
        const unit = self.units.items[unit_idx];
        var might_fail = false;

        const path_status = self.pathStatus(unit_idx);
        if (path_status == .failed) return .{ .min = 0, .max = 0 };
        if (path_status == .unresolved) might_fail = true;

        const target = unit.command.?.to().?;

        var target_country_mb: ?Country = null;
        if (self.h2hAgainst(unit_idx)) |h2h_idx| {
            const h2h = self.units.items[h2h_idx];
            target_country_mb = h2h.country;
        } else if (self.h2hCandidateAgainst(unit_idx) != null) {
            might_fail = true;
        } else if (self.unitIdxAtArea(target)) |target_unit_idx| {
            const target_unit = self.units.items[target_unit_idx];
            if (target_unit.command.?.to() != null) {
                switch (target_unit.status) {
                    .succeeded => {},
                    .unresolved => might_fail = true,
                    .failed, .illegal => target_country_mb = target_unit.country,
                }
            } else {
                target_country_mb = target_unit.country;
            }
        }

        if (target_country_mb) |target_country| if (std.meta.eql(target_country, unit.country)) return .{ .min = 0, .max = 0 };

        var strength = Strength{ .min = 1, .max = 1 };
        var support_iter = self.supportIterator(unit_idx, target_country_mb);

        while (support_iter.next()) |support_idx| {
            const support = self.units.items[support_idx];
            if (support.status == .succeeded) strength.inc();
            if (support.status == .unresolved) strength.incMax();
        }
        if (might_fail) strength.min = 0;
        return strength;
    }

    fn holdStrengthAt(self: Game, to: Province) Strength {
        const unit_idx = self.unitIdxAtArea(to) orelse return .{ .min = 0, .max = 0 };
        const unit = self.units.items[unit_idx];
        if (unit.command.?.to() != null) {
            switch (unit.status) {
                .succeeded => return .{ .min = 0, .max = 0 },
                .unresolved => return .{ .min = 0, .max = 1 },
                .failed => return .{ .min = 1, .max = 1 },
                .illegal => if (self.options.illegal_commands == .treat_stationary_as_hold) return .{ .min = 1, .max = 1 },
            }
        }
        var strength = Strength{ .min = 1, .max = 1 };
        var support_iter = self.supportIteratorAny(unit_idx);
        while (support_iter.next()) |support_idx| {
            const support = self.units.items[support_idx];
            if (support.status == .succeeded) strength.inc();
            if (support.status == .unresolved) strength.incMax();
        }
        return strength;
    }

    fn getDefendStrengthAgainst(self: Game, unit_idx: idint) Strength {
        var might_dodge = false;
        var h2h_idx: idint = undefined;

        if (self.h2hAgainst(unit_idx)) |idx| {
            h2h_idx = idx;
        } else if (self.h2hCandidateAgainst(unit_idx)) |idx| {
            h2h_idx = idx;
            might_dodge = true;
        } else return .{ .min = 0, .max = 0 };

        var strength = Strength{ .min = 1, .max = 1 };
        var h2h_support_iter = self.supportIteratorAny(h2h_idx);

        while (h2h_support_iter.next()) |h2h_support_idx| {
            const h2h_support = self.units.items[h2h_support_idx];
            if (h2h_support.status == .succeeded) strength.inc();
            if (h2h_support.status == .unresolved) strength.incMax();
        }

        if (might_dodge) strength.min = 0;
        return strength;
    }

    fn combinedPreventStrengthAgainst(self: Game, unit_idx: idint) Strength {
        const unit = self.units.items[unit_idx];
        var opponent_iter = self.areaMoveIterator(unit.command.?.to().?);
        var strength: Strength = .{ .min = 0, .max = 0 };

        while (opponent_iter.next()) |opponent_idx| {
            if (opponent_idx == unit_idx) continue;
            strength = strength.mix(self.preventStrengthOf(opponent_idx));
        }

        return strength;
    }

    fn preventStrengthOf(self: Game, opponent_idx: idint) Strength {
        var might_fail = false;
        const path_status = self.pathStatus(opponent_idx);
        if (path_status == .failed) return .{ .min = 0, .max = 0 };
        if (path_status == .unresolved) might_fail = true;

        if (self.h2hAgainst(opponent_idx)) |h2h_idx| {
            const h2h = self.units.items[h2h_idx];
            if (h2h.status == .succeeded) return .{ .min = 0, .max = 0 };
            if (h2h.status == .unresolved) might_fail = true;
        } else if (self.h2hCandidateAgainst(opponent_idx) != null) {
            might_fail = true;
        }

        var strength = Strength{ .min = 1, .max = 1 };
        var support_iter = self.supportIteratorAny(opponent_idx);
        while (support_iter.next()) |support_idx| {
            const support = self.units.items[support_idx];
            if (support.status == .succeeded) strength.inc();
            if (support.status == .unresolved) strength.incMax();
        }

        if (might_fail) strength.min = 0;
        return strength;
    }

    /// Returns the status of unit's influence on its target.
    fn pathStatus(self: Game, unit_idx: idint) Status {
        const unit = self.units.items[unit_idx];
        switch (unit.command.?) {
            .move => |move| if (self.map.border(unit.province, move.to)) return .succeeded else return .failed,
            .convoy_move => |cm| {
                const convoy_path_status = self.convoyPathStatus(unit_idx);
                if (convoy_path_status == .failed and self.options.convoy_can_fallback and self.map.border(unit.province, cm.to)) return .succeeded;
                return convoy_path_status;
            },
            else => unreachable,
        }
    }

    /// Returns the status of unit's influence on its target via land route. Takes convoy fallback into consideration.
    fn landPathStatus(self: Game, unit_idx: idint) Status {
        const unit = self.units.items[unit_idx];
        switch (unit.command.?) {
            .move => |move| if (self.map.border(unit.province, move.to)) return .succeeded else return .failed,
            .convoy_move => |cm| {
                if (!self.options.convoy_can_fallback) return .failed;
                if (!self.map.border(unit.province, cm.to)) return .failed;
                switch (self.convoyPathStatus(unit_idx)) {
                    .succeeded => return .failed,
                    .failed => return .succeeded,
                    .unresolved => return .unresolved,
                    .illegal => unreachable,
                }
            },
            else => unreachable,
        }
    }

    /// Returns the status of unit's influence on its target via convoy route.
    fn convoyPathStatus(self: Game, unit_idx: idint) Status {
        const unit = self.units.items[unit_idx];
        var transport_iter = self.convoyIterator(unit_idx);

        @memset(self.area_buf, 2);
        while (transport_iter.next()) |transport_idx| {
            const transport = self.units.items[transport_idx];
            // Enable provinces that *can* help us.
            if (transport.status == .succeeded or transport.status == .unresolved) self.area_buf[transport.province.water.id] = 0;
        }
        if (!self.hasConvoyPathBuf(unit.province, unit.command.?.convoy_move.to, null)) return .failed;
        transport_iter.unit_idx = 0;

        @memset(self.area_buf, 2);
        while (transport_iter.next()) |transport_idx| {
            const transport = self.units.items[transport_idx];
            // Enable provinces that *will* help us.
            if (transport.status == .succeeded) self.area_buf[transport.province.water.id] = 0;
        }
        if (self.hasConvoyPathBuf(unit.province, unit.command.?.convoy_move.to, null)) return .succeeded;

        return .unresolved;
    }

    /// The unit is dislodged if it stays in place and another unit has succesfully moved to its province.
    fn notDislodgedStatus(self: Game, unit_idx: idint) Status {
        const unit = self.units.items[unit_idx];
        switch (unit.command.?) {
            .move, .convoy_move => switch (unit.status) {
                .succeeded => return .succeeded,
                .unresolved => return .unresolved,
                else => {},
            },
            else => {},
        }
        var move_iter = self.areaMoveIterator(unit.province);
        while (move_iter.next()) |moving_unit_idx| {
            const moving_unit = self.units.items[moving_unit_idx];
            switch (moving_unit.status) {
                .succeeded => return .failed,
                .unresolved => return .unresolved,
                else => {},
            }
        }
        return .succeeded;
    }

    /// The support is cut if it is dislodged, or if a unit of another power not targeted by the support has a successful path to it.
    fn notCutStatus(self: Game, unit_idx: idint) Status {
        const unit = self.units.items[unit_idx];
        switch (unit.command.?) {
            .support_move => |support| {
                var move_iter = self.areaMoveIterator(unit.province);
                while (move_iter.next()) |moving_unit_idx| {
                    const moving_unit = self.units.items[moving_unit_idx];
                    if (std.meta.eql(moving_unit.country, unit.country)) continue;
                    if (self.map.sameArea(moving_unit.province, support.to)) {
                        switch (moving_unit.status) {
                            .succeeded => return .failed,
                            .unresolved => return .unresolved,
                            .failed => {},
                            .illegal => unreachable,
                        }
                    } else {
                        switch (self.pathStatus(moving_unit_idx)) {
                            .succeeded => return .failed,
                            .unresolved => return .unresolved,
                            .failed => {},
                            .illegal => unreachable,
                        }
                    }
                }
                return .succeeded;
            },
            .support_hold => {
                var move_iter = self.areaMoveIterator(unit.province);
                while (move_iter.next()) |moving_unit_idx| {
                    const moving_unit = self.units.items[moving_unit_idx];
                    if (std.meta.eql(moving_unit.country, unit.country)) continue;
                    switch (self.pathStatus(moving_unit_idx)) {
                        .succeeded => return .failed,
                        .unresolved => return .unresolved,
                        .failed => {},
                        .illegal => unreachable,
                    }
                }
                return .succeeded;
            },
            else => unreachable,
        }
    }

    //  |-------------------|
    //--|  Legal iterators  |
    //  |-------------------|

    /// Iterates through legal retreat destinations of the given unit.
    pub const LegalRetreatIterator = struct {
        game: Game,
        unit_idx: idint,
        neighbour_iter: Map.NeighbourIterator,

        pub fn next(self: *LegalRetreatIterator) ?Province {
            while (self.neighbour_iter.next()) |neighbour| {
                if (self.game.isLegalRetreat(null, self.unit_idx, neighbour) catch unreachable) return neighbour;
            }
            return null;
        }
    };

    /// Returns iterator through legal retreat destinations of the given unit.
    pub fn legalRetreatIterator(self: Game, unit_idx: idint) WrongPhase!LegalRetreatIterator {
        if (!self.season.isRetreat()) return error.WrongPhase;
        const unit = self.units.items[unit_idx];
        return .{ .game = self, .unit_idx = unit_idx, .neighbour_iter = self.map.neighbourIterator(unit.province) };
    }

    /// Iterates through legal move commands of the given unit.
    pub const LegalMoveIterator = struct {
        neighbours_iter: Map.NeighbourIterator,

        pub fn next(self: *LegalMoveIterator) ?Command {
            while (self.neighbours_iter.next()) |neighbour| {
                return .{ .move = .{ .to = neighbour } };
            }
            return null;
        }
    };

    /// Returns iterator through legal move commands of the given unit.
    pub fn legalMoveIterator(self: Game, unit_idx: idint) WrongPhase!LegalMoveIterator {
        if (!self.season.isMove()) return error.WrongPhase;
        const unit = self.units.items[unit_idx];
        return .{ .neighbours_iter = self.map.neighbourIterator(unit.province) };
    }

    /// Iterates through legal move via convoy commands of the given unit.
    pub const LegalConvoyMoveIterator = struct {
        // Ideally, this should not do recursive convoy calculations for every land.
        game: Game,
        unit_idx: idint,
        land_iter: LandIterator,

        pub fn next(self: *LegalConvoyMoveIterator) ?Command {
            const unit = self.game.units.items[self.unit_idx];
            if (unit.province != .land) return null;
            while (self.land_iter.next()) |land| {
                const command = Command{ .convoy_move = .{ .to = land.province() } };
                if (self.game.isLegalCommand(null, self.unit_idx, command) catch unreachable) return command;
            }
            return null;
        }
    };

    /// Returns iterator through legal move via convoy commands for the given unit.
    pub fn legalConvoyMoveIterator(self: Game, unit_idx: idint) WrongPhase!LegalConvoyMoveIterator {
        if (!self.season.isMove()) return error.WrongPhase;
        return LegalConvoyMoveIterator{ .game = self, .unit_idx = unit_idx, .land_iter = self.landIterator() };
    }

    /// Iterates through legal support commands of one unit for the other.
    pub const LegalSupportFromIterator = struct {
        // There is some redundancy with having `game` and `neighbour_iter` with `land_iter` here.
        // They can be reimplemented in here.
        // Ideally, this should not do recursive convoy calculations for every land.
        game: Game,
        unit_idx: idint,
        other_idx: idint,
        neighbours_iter: Map.NeighbourIterator,
        land_iter: LandIterator,
        checked_hold: bool = false,

        pub fn next(self: *LegalSupportFromIterator) ?Command {
            if (self.unit_idx == self.other_idx) return null;
            const unit = self.game.units.items[self.unit_idx];
            const other = self.game.units.items[self.other_idx];
            if (!self.checked_hold) {
                self.checked_hold = true;
                if (self.game.canSupportTo(unit.province, other.province)) return .{ .support_hold = .{ .at = other.province } };
            }
            while (self.neighbours_iter.next()) |neighbour| {
                const command = Command{ .support_move = .{ .from = other.province, .to = neighbour } };
                if (self.game.isLegalCommand(null, self.unit_idx, command) catch unreachable) return command;
            }
            while (self.land_iter.next()) |land| {
                if (self.game.map.border(other.province, land.province())) continue;
                const command = Command{ .support_move = .{ .from = other.province, .to = land.province() } };
                if (self.game.isLegalCommand(null, self.unit_idx, command) catch unreachable) return command;
            }
            return null;
        }
    };

    /// Returns iterator through legal support commands of one unit for the other.
    pub fn legalSupportFromIterator(self: Game, unit_idx: idint, other_idx: idint) WrongPhase!LegalSupportFromIterator {
        if (!self.season.isMove()) return error.WrongPhase;
        return .{
            .game = self,
            .unit_idx = unit_idx,
            .other_idx = other_idx,
            .neighbours_iter = self.map.neighbourIterator(self.units.items[other_idx].province),
            .land_iter = self.landIterator(),
        };
    }

    /// Iterates through all legal supports of the unit.
    pub const LegalSupportAllIterator = struct {
        support_iter: LegalSupportFromIterator,

        pub fn next(self: *LegalSupportAllIterator) ?Command {
            while (true) {
                if (self.support_iter.next()) |command| return command;
                self.support_iter.other_idx += 1;
                if (self.support_iter.other_idx >= self.support_iter.game.units.items.len) break;
                self.support_iter.checked_hold = false;
                self.support_iter.neighbours_iter = self.support_iter.game.map.neighbourIterator(self.support_iter.game.units.items[self.support_iter.other_idx].province);
                self.support_iter.land_iter = self.support_iter.game.landIterator();
            }
            return null;
        }
    };

    /// Returns iterator through all legal supports of the unit.
    pub fn legalSupportAllIterator(self: Game, unit_idx: idint) WrongPhase!LegalSupportAllIterator {
        if (!self.season.isMove()) return error.WrongPhase;
        return LegalSupportAllIterator{ .support_iter = self.legalSupportFromIterator(unit_idx, 0) catch unreachable };
    }

    /// Iterates through legal convoy transport commands of one unit for the other.
    pub const LegalTransportFromIterator = struct {
        // There is some redundancy with having `game` and `land_iter` here.
        // Ideally, this should not do recursive convoy calculations for every land.
        game: Game,
        unit_idx: idint,
        other_idx: idint,
        land_iter: LandIterator,

        pub fn next(self: *LegalTransportFromIterator) ?Command {
            if (self.unit_idx == self.other_idx) return null;
            const unit = self.game.units.items[self.unit_idx];
            const other = self.game.units.items[self.other_idx];
            if (unit.province != .water) return null;
            if (other.province != .land) return null;
            while (self.land_iter.next()) |land| {
                const command = Command{ .convoy_transport = .{ .from = other.province, .to = land.province() } };
                if (self.game.isLegalCommand(null, self.unit_idx, command) catch unreachable) return command;
            }
            return null;
        }
    };

    /// Returns iterator through legal convoy transport commands of one unit for the other.
    pub fn legalTransportFromIterator(self: Game, unit_idx: idint, other_idx: idint) WrongPhase!LegalTransportFromIterator {
        if (!self.season.isMove()) return error.WrongPhase;
        return .{
            .game = self,
            .unit_idx = unit_idx,
            .other_idx = other_idx,
            .land_iter = self.landIterator(),
        };
    }

    /// Iterates through all legal convoy transport commands of the unit.
    pub const LegalTransportAllIterator = struct {
        transport_iter: LegalTransportFromIterator,

        pub fn next(self: *LegalTransportAllIterator) ?Command {
            while (self.transport_iter.other_idx < self.transport_iter.game.units.items.len) {
                if (self.transport_iter.next()) |command| return command;
                self.transport_iter.other_idx += 1;
                self.transport_iter.land_iter = self.transport_iter.game.landIterator();
            }
            return null;
        }
    };

    /// Returns iterator through all legal convoy transport commands of the unit.
    pub fn legalTransportAllIterator(self: Game, unit_idx: idint) WrongPhase!LegalTransportAllIterator {
        if (!self.season.isMove()) return error.WrongPhase;
        return LegalTransportAllIterator{ .transport_iter = self.legalTransportFromIterator(unit_idx, 0) catch unreachable };
    }
};
