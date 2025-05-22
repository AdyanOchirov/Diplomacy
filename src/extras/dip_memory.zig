const std = @import("std");
const dip = @import("dip");

pub const DummyUnit = struct {
    province: dip.Province,
    country: dip.Country,
};

/// Holds all information about units and orders of a single move phase.
pub const MoveSnapshot = struct {
    units: []const dip.Unit,
    retreats: []const dip.Retreat,

    pub fn retreatIdxOf(self: MoveSnapshot, unit_idx: dip.idint) ?dip.idint {
        for (self.retreats, 0..) |retreat, idx| if (retreat.unit_idx == unit_idx) return @intCast(idx);
        return null;
    }
};

/// Holds all information about units, builds and disbands of a single build phase.
pub const BuildSnapshot = struct {
    units: []const DummyUnit,
    builds: []const dip.Province,
    disbands: []const dip.idint,

    pub fn isDisbanded(self: BuildSnapshot, unit_idx: dip.idint) bool {
        for (self.disbands) |disband_idx| if (disband_idx == unit_idx) return true;
        return false;
    }
};

/// Holds all information about units and orders of a single year.
pub const YearSnapshot = struct {
    spring: MoveSnapshot,
    fall: MoveSnapshot,
    winter: BuildSnapshot,
};

pub const Season = enum { spring, fall, winter };

/// Holds all information about units and orders of the entire game.
/// Every step function of game must be called from here for accurate results.
pub const Memory = struct {
    arena: std.heap.ArenaAllocator,
    start_year: u16,
    year_snapshots: std.ArrayListUnmanaged(YearSnapshot),
    unfinished_snapshot: YearSnapshot = undefined,
    current_season: Season = .spring,

    pub fn init(allocator: std.mem.Allocator, start_year: u16) std.mem.Allocator.Error!Memory {
        const arena = std.heap.ArenaAllocator.init(allocator);
        return .{ .arena = arena, .start_year = start_year, .year_snapshots = .{} };
    }

    pub fn deinit(self: *Memory) void {
        self.arena.deinit();
        self.* = undefined;
    }

    pub fn currentYear(self: Memory) u16 {
        const years_passed: u16 = @intCast(self.year_snapshots.items.len);
        return self.start_year + years_passed;
    }

    const StepError = dip.WrongPhase || std.mem.Allocator.Error;

    /// Memorizes the information about spring moves and prepares to memorize fall.
    /// Game must be in `spring_end` phase.
    pub fn rememberSpring(self: *Memory, game: *dip.Game) StepError!void {
        if (game.season != .spring_end or self.current_season != .spring) return error.WrongPhase;

        const units = try self.arena.allocator().dupe(dip.Unit, game.units.items);
        const retreats = try self.arena.allocator().dupe(dip.Retreat, game.retreats.items);
        const spring = MoveSnapshot{ .units = units, .retreats = retreats };

        self.unfinished_snapshot.spring = spring;
        self.current_season = .fall;
    }

    /// Memorizes the information about fall moves and prepares to memorize winter.
    /// Game must be in `fall_end` phase.
    pub fn rememberFall(self: *Memory, game: *dip.Game) StepError!void {
        if (game.season != .fall_end or self.current_season != .fall) return error.WrongPhase;

        const units = try self.arena.allocator().dupe(dip.Unit, game.units.items);
        const retreats = try self.arena.allocator().dupe(dip.Retreat, game.retreats.items);
        const fall = MoveSnapshot{ .units = units, .retreats = retreats };

        self.unfinished_snapshot.fall = fall;
        self.current_season = .winter;
    }

    /// Memorizes the information about winter orders and prepares to memorize spring.
    /// Game must be in `winter_end` phase.
    pub fn rememberWinter(self: *Memory, game: *dip.Game) StepError!void {
        if (game.season != .winter_end or self.current_season != .winter) return error.WrongPhase;

        const dummies = try self.arena.allocator().alloc(DummyUnit, game.units.items.len);
        const builds = try self.arena.allocator().dupe(dip.Province, game.builds.items);
        const disbands = try self.arena.allocator().dupe(dip.idint, game.disbands.items);
        for (game.units.items, dummies) |unit, *dummy| {
            dummy.province = unit.province;
            dummy.country = unit.country;
        }
        const winter = BuildSnapshot{ .units = dummies, .builds = builds, .disbands = disbands };

        self.unfinished_snapshot.winter = winter;
        try self.year_snapshots.append(self.arena.allocator(), self.unfinished_snapshot);
        self.current_season = .spring;
    }

    /// Returns the snapshot of spring of the given year.
    pub fn springOf(self: Memory, year: u16) ?MoveSnapshot {
        if (year < self.start_year or year > self.currentYear()) return null;
        if (year == self.currentYear()) {
            if (self.current_season != .spring) return self.unfinished_snapshot.spring else return null;
        } else {
            return self.year_snapshots.items[year - self.start_year].spring;
        }
    }

    /// Returns the snapshot of fall of the given year.
    pub fn fallOf(self: Memory, year: u16) ?MoveSnapshot {
        if (year < self.start_year or year > self.currentYear()) return null;
        if (year == self.currentYear()) {
            if (self.current_season == .winter) return self.unfinished_snapshot.fall else return null;
        } else {
            return self.year_snapshots.items[year - self.start_year].fall;
        }
    }

    /// Returns the snapshot of winter of the given year.
    pub fn winterOf(self: Memory, year: u16) ?BuildSnapshot {
        if (year < self.start_year or year >= self.currentYear()) return null;
        return self.year_snapshots.items[year - self.start_year].winter;
    }
};
