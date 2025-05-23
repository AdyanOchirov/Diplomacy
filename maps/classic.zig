const dip = @import("dip");
const dip_names = @import("dip_names");
const std = @import("std");

pub const start_year: u16 = 1901;

pub fn classicGame(allocator: std.mem.Allocator) dip_names.InitError!dip_names.GameAndNames {
    return dip_names.NamesData.initGameAndNames(allocator, classic_areas, classic_pairs, classic_supply_centers, classic_start, classic_shortcuts);
}

pub fn avsfGame(allocator: std.mem.Allocator) dip_names.InitError!dip_names.GameAndNames {
    return dip_names.NamesData.initGameAndNames(allocator, classic_areas, classic_pairs, classic_supply_centers, af_start, classic_shortcuts);
}

const classic_areas: []const dip_names.Area = &.{
    .{ .name = "Adriatic Sea", .coasts = null },
    .{ .name = "Aegean Sea", .coasts = null },
    .{ .name = "Baltic Sea", .coasts = null },
    .{ .name = "Barents Sea", .coasts = null },
    .{ .name = "Black Sea", .coasts = null },
    .{ .name = "Eastern Mediterranean Sea", .coasts = null },
    .{ .name = "English Channel", .coasts = null },
    .{ .name = "Gulf of Bothnia", .coasts = null },
    .{ .name = "Gulf of Lyon", .coasts = null },
    .{ .name = "Helgoland Bight", .coasts = null },
    .{ .name = "Ionian Sea", .coasts = null },
    .{ .name = "Irish Sea", .coasts = null },
    .{ .name = "Mid-Atlantic Ocean", .coasts = null },
    .{ .name = "North Atlantic Ocean", .coasts = null },
    .{ .name = "North Sea", .coasts = null },
    .{ .name = "Norwegian Sea", .coasts = null },
    .{ .name = "Skagerrak", .coasts = null },
    .{ .name = "Tyrrhenian Sea", .coasts = null },
    .{ .name = "Western Mediterranean Sea", .coasts = null },
    .{ .name = "Albania", .coasts = &.{"Albania Coast"} },
    .{ .name = "Apulia", .coasts = &.{"Apulia Coast"} },
    .{ .name = "Ankara", .coasts = &.{"Ankara Coast"} },
    .{ .name = "Armenia", .coasts = &.{"Armenia Coast"} },
    .{ .name = "Belgium", .coasts = &.{"Belgium Coast"} },
    .{ .name = "Berlin", .coasts = &.{"Berlin Coast"} },
    .{ .name = "Bohemia", .coasts = &.{} },
    .{ .name = "Brest", .coasts = &.{"Brest Coast"} },
    .{ .name = "Budapest", .coasts = &.{} },
    .{ .name = "Bulgaria", .coasts = &.{ "Bulgaria East Coast", "Bulgaria South Coast" } },
    .{ .name = "Burgundy", .coasts = &.{} },
    .{ .name = "Clyde", .coasts = &.{"Clyde Coast"} },
    .{ .name = "Constantinople", .coasts = &.{"Constantinople Coast"} },
    .{ .name = "Denmark", .coasts = &.{"Denmark Coast"} },
    .{ .name = "Edinburgh", .coasts = &.{"Edinburgh Coast"} },
    .{ .name = "Finland", .coasts = &.{"Finland Coast"} },
    .{ .name = "Gascony", .coasts = &.{"Gascony Coast"} },
    .{ .name = "Galicia", .coasts = &.{} },
    .{ .name = "Greece", .coasts = &.{"Greece Coast"} },
    .{ .name = "Holland", .coasts = &.{"Holland Coast"} },
    .{ .name = "Kiel", .coasts = &.{"Kiel Coast"} },
    .{ .name = "London", .coasts = &.{"London Coast"} },
    .{ .name = "Liverpool", .coasts = &.{"Liverpool Coast"} },
    .{ .name = "Livonia", .coasts = &.{"Livonia Coast"} },
    .{ .name = "Marseilles", .coasts = &.{"Marseilles Coast"} },
    .{ .name = "Moscow", .coasts = &.{} },
    .{ .name = "Munich", .coasts = &.{} },
    .{ .name = "Naples", .coasts = &.{"Naples Coast"} },
    .{ .name = "Norway", .coasts = &.{"Norway Coast"} },
    .{ .name = "Paris", .coasts = &.{} },
    .{ .name = "Picardy", .coasts = &.{"Picardy Coast"} },
    .{ .name = "Piedmont", .coasts = &.{"Piedmont Coast"} },
    .{ .name = "Portugal", .coasts = &.{"Portugal Coast"} },
    .{ .name = "Prussia", .coasts = &.{"Prussia Coast"} },
    .{ .name = "Rome", .coasts = &.{"Rome Coast"} },
    .{ .name = "Ruhr", .coasts = &.{} },
    .{ .name = "North Africa", .coasts = &.{"North Africa Coast"} },
    .{ .name = "Rumania", .coasts = &.{"Rumania Coast"} },
    .{ .name = "Serbia", .coasts = &.{} },
    .{ .name = "Silesia", .coasts = &.{} },
    .{ .name = "Sevastopol", .coasts = &.{"Sevastopol Coast"} },
    .{ .name = "Smyrna", .coasts = &.{"Smyrna Coast"} },
    .{ .name = "Spain", .coasts = &.{ "Spain North Coast", "Spain South Coast" } },
    .{ .name = "St. Petersburg", .coasts = &.{ "St. Petersburg North Coast", "St. Petersburg South Coast" } },
    .{ .name = "Sweden", .coasts = &.{"Sweden Coast"} },
    .{ .name = "Syria", .coasts = &.{"Syria Coast"} },
    .{ .name = "Trieste", .coasts = &.{"Trieste Coast"} },
    .{ .name = "Tunis", .coasts = &.{"Tunis Coast"} },
    .{ .name = "Tuscany", .coasts = &.{"Tuscany Coast"} },
    .{ .name = "Tyrolia", .coasts = &.{} },
    .{ .name = "Ukraine", .coasts = &.{} },
    .{ .name = "Venice", .coasts = &.{"Venice Coast"} },
    .{ .name = "Vienna", .coasts = &.{} },
    .{ .name = "Warsaw", .coasts = &.{} },
    .{ .name = "Wales", .coasts = &.{"Wales Coast"} },
    .{ .name = "Yorkshire", .coasts = &.{"Yorkshire Coast"} },
};

const classic_pairs: []const dip_names.Pair = &.{
    .{ "North Atlantic Ocean", "Norwegian Sea" },
    .{ "North Atlantic Ocean", "Mid-Atlantic Ocean" },
    .{ "North Atlantic Ocean", "Irish Sea" },
    .{ "North Atlantic Ocean", "Clyde Coast" },
    .{ "North Atlantic Ocean", "Liverpool Coast" },
    .{ "Norwegian Sea", "North Sea" },
    .{ "Norwegian Sea", "Barents Sea" },
    .{ "Norwegian Sea", "Clyde Coast" },
    .{ "Norwegian Sea", "Edinburgh Coast" },
    .{ "Norwegian Sea", "Norway Coast" },
    .{ "Barents Sea", "Norway Coast" },
    .{ "Barents Sea", "St. Petersburg North Coast" },
    .{ "Mid-Atlantic Ocean", "Irish Sea" },
    .{ "Mid-Atlantic Ocean", "English Channel" },
    .{ "Mid-Atlantic Ocean", "Western Mediterranean Sea" },
    .{ "Mid-Atlantic Ocean", "North Africa Coast" },
    .{ "Mid-Atlantic Ocean", "Spain North Coast" },
    .{ "Mid-Atlantic Ocean", "Spain South Coast" },
    .{ "Mid-Atlantic Ocean", "Portugal Coast" },
    .{ "Mid-Atlantic Ocean", "Gascony Coast" },
    .{ "Mid-Atlantic Ocean", "Brest Coast" },
    .{ "Irish Sea", "English Channel" },
    .{ "Irish Sea", "Liverpool Coast" },
    .{ "Irish Sea", "Wales Coast" },
    .{ "English Channel", "Wales Coast" },
    .{ "English Channel", "London Coast" },
    .{ "English Channel", "North Sea" },
    .{ "English Channel", "Belgium Coast" },
    .{ "English Channel", "Picardy Coast" },
    .{ "English Channel", "Brest Coast" },
    .{ "North Sea", "Skagerrak" },
    .{ "North Sea", "Helgoland Bight" },
    .{ "North Sea", "Norway Coast" },
    .{ "North Sea", "Holland Coast" },
    .{ "North Sea", "Belgium Coast" },
    .{ "North Sea", "London Coast" },
    .{ "North Sea", "Yorkshire Coast" },
    .{ "North Sea", "Edinburgh Coast" },
    .{ "North Sea", "Denmark Coast" },
    .{ "Skagerrak", "Norway Coast" },
    .{ "Skagerrak", "Sweden Coast" },
    .{ "Skagerrak", "Denmark Coast" },
    .{ "Helgoland Bight", "Denmark Coast" },
    .{ "Helgoland Bight", "Kiel Coast" },
    .{ "Helgoland Bight", "Holland Coast" },
    .{ "Baltic Sea", "Sweden Coast" },
    .{ "Baltic Sea", "Gulf of Bothnia" },
    .{ "Baltic Sea", "Livonia Coast" },
    .{ "Baltic Sea", "Prussia Coast" },
    .{ "Baltic Sea", "Berlin Coast" },
    .{ "Baltic Sea", "Kiel Coast" },
    .{ "Baltic Sea", "Denmark Coast" },
    .{ "Gulf of Bothnia", "Finland Coast" },
    .{ "Gulf of Bothnia", "St. Petersburg South Coast" },
    .{ "Gulf of Bothnia", "Livonia Coast" },
    .{ "Gulf of Bothnia", "Sweden Coast" },
    .{ "Western Mediterranean Sea", "Spain South Coast" },
    .{ "Western Mediterranean Sea", "Gulf of Lyon" },
    .{ "Western Mediterranean Sea", "Tyrrhenian Sea" },
    .{ "Western Mediterranean Sea", "Tunis Coast" },
    .{ "Western Mediterranean Sea", "North Africa Coast" },
    .{ "Gulf of Lyon", "Marseilles Coast" },
    .{ "Gulf of Lyon", "Spain South Coast" },
    .{ "Gulf of Lyon", "Piedmont Coast" },
    .{ "Gulf of Lyon", "Tuscany Coast" },
    .{ "Gulf of Lyon", "Tyrrhenian Sea" },
    .{ "Tyrrhenian Sea", "Tuscany Coast" },
    .{ "Tyrrhenian Sea", "Rome Coast" },
    .{ "Tyrrhenian Sea", "Naples Coast" },
    .{ "Tyrrhenian Sea", "Ionian Sea" },
    .{ "Tyrrhenian Sea", "Tunis Coast" },
    .{ "Ionian Sea", "Tunis Coast" },
    .{ "Ionian Sea", "Naples Coast" },
    .{ "Ionian Sea", "Apulia Coast" },
    .{ "Ionian Sea", "Adriatic Sea" },
    .{ "Ionian Sea", "Albania Coast" },
    .{ "Ionian Sea", "Greece Coast" },
    .{ "Ionian Sea", "Aegean Sea" },
    .{ "Ionian Sea", "Eastern Mediterranean Sea" },
    .{ "Aegean Sea", "Greece Coast" },
    .{ "Aegean Sea", "Bulgaria South Coast" },
    .{ "Aegean Sea", "Constantinople Coast" },
    .{ "Aegean Sea", "Smyrna Coast" },
    .{ "Aegean Sea", "Eastern Mediterranean Sea" },
    .{ "Eastern Mediterranean Sea", "Smyrna Coast" },
    .{ "Eastern Mediterranean Sea", "Syria Coast" },
    .{ "Adriatic Sea", "Apulia Coast" },
    .{ "Adriatic Sea", "Venice Coast" },
    .{ "Adriatic Sea", "Trieste Coast" },
    .{ "Adriatic Sea", "Albania Coast" },
    .{ "Black Sea", "Constantinople Coast" },
    .{ "Black Sea", "Bulgaria East Coast" },
    .{ "Black Sea", "Rumania Coast" },
    .{ "Black Sea", "Sevastopol Coast" },
    .{ "Black Sea", "Armenia Coast" },
    .{ "Black Sea", "Ankara Coast" },

    //Coast Adjacencies
    .{ "Clyde Coast", "Edinburgh Coast" },
    .{ "Clyde Coast", "Liverpool Coast" },
    .{ "Edinburgh Coast", "Yorkshire Coast" },
    .{ "Liverpool Coast", "Wales Coast" },
    .{ "Wales Coast", "London Coast" },
    .{ "Yorkshire Coast", "London Coast" },
    .{ "Norway Coast", "Sweden Coast" },
    .{ "Norway Coast", "St. Petersburg North Coast" },
    .{ "Sweden Coast", "Denmark Coast" },
    .{ "Sweden Coast", "Finland Coast" },
    .{ "Denmark Coast", "Kiel Coast" },
    .{ "Finland Coast", "St. Petersburg South Coast" },
    .{ "Livonia Coast", "St. Petersburg South Coast" },
    .{ "Livonia Coast", "Prussia Coast" },
    .{ "Prussia Coast", "Berlin Coast" },
    .{ "Berlin Coast", "Kiel Coast" },
    .{ "Kiel Coast", "Holland Coast" },
    .{ "Holland Coast", "Belgium Coast" },
    .{ "Belgium Coast", "Picardy Coast" },
    .{ "Picardy Coast", "Brest Coast" },
    .{ "Brest Coast", "Gascony Coast" },
    .{ "Gascony Coast", "Spain North Coast" },
    .{ "Portugal Coast", "Spain North Coast" },
    .{ "Portugal Coast", "Spain South Coast" },
    .{ "Marseilles Coast", "Spain South Coast" },
    .{ "Marseilles Coast", "Piedmont Coast" },
    .{ "Piedmont Coast", "Tuscany Coast" },
    .{ "Tuscany Coast", "Rome Coast" },
    .{ "Rome Coast", "Naples Coast" },
    .{ "Naples Coast", "Apulia Coast" },
    .{ "Apulia Coast", "Venice Coast" },
    .{ "North Africa Coast", "Tunis Coast" },
    .{ "Venice Coast", "Trieste Coast" },
    .{ "Trieste Coast", "Albania Coast" },
    .{ "Albania Coast", "Greece Coast" },
    .{ "Greece Coast", "Bulgaria South Coast" },
    .{ "Constantinople Coast", "Bulgaria South Coast" },
    .{ "Constantinople Coast", "Bulgaria East Coast" },
    .{ "Constantinople Coast", "Ankara Coast" },
    .{ "Constantinople Coast", "Smyrna Coast" },
    .{ "Smyrna Coast", "Syria Coast" },
    .{ "Ankara Coast", "Armenia Coast" },
    .{ "Armenia Coast", "Sevastopol Coast" },
    .{ "Sevastopol Coast", "Rumania Coast" },
    .{ "Rumania Coast", "Bulgaria East Coast" },

    // Land Adjacencies
    .{ "Apulia", "Venice" },
    .{ "Albania", "Trieste" },
    .{ "Clyde", "Edinburgh" },
    .{ "Clyde", "Liverpool" },
    .{ "Liverpool", "Edinburgh" },
    .{ "Liverpool", "Yorkshire" },
    .{ "Liverpool", "Wales" },
    .{ "Edinburgh", "Yorkshire" },
    .{ "Wales", "London" },
    .{ "Wales", "Yorkshire" },
    .{ "Yorkshire", "London" },
    .{ "Norway", "Sweden" },
    .{ "Norway", "Finland" },
    .{ "Norway", "St. Petersburg" },
    .{ "Sweden", "Finland" },
    .{ "Sweden", "Denmark" },
    .{ "Finland", "St. Petersburg" },
    .{ "Denmark", "Kiel" },
    .{ "St. Petersburg", "Livonia" },
    .{ "St. Petersburg", "Moscow" },
    .{ "Livonia", "Moscow" },
    .{ "Livonia", "Warsaw" },
    .{ "Livonia", "Prussia" },
    .{ "Moscow", "Warsaw" },
    .{ "Moscow", "Ukraine" },
    .{ "Moscow", "Sevastopol" },
    .{ "Warsaw", "Prussia" },
    .{ "Warsaw", "Silesia" },
    .{ "Warsaw", "Galicia" },
    .{ "Warsaw", "Ukraine" },
    .{ "Ukraine", "Galicia" },
    .{ "Ukraine", "Sevastopol" },
    .{ "Ukraine", "Rumania" },
    .{ "Sevastopol", "Armenia" },
    .{ "Sevastopol", "Rumania" },
    .{ "Armenia", "Syria" },
    .{ "Armenia", "Smyrna" },
    .{ "Armenia", "Ankara" },
    .{ "Ankara", "Smyrna" },
    .{ "Ankara", "Constantinople" },
    .{ "Smyrna", "Constantinople" },
    .{ "Smyrna", "Syria" },
    .{ "Constantinople", "Bulgaria" },
    .{ "Bulgaria", "Rumania" },
    .{ "Bulgaria", "Greece" },
    .{ "Bulgaria", "Serbia" },
    .{ "Rumania", "Galicia" },
    .{ "Rumania", "Budapest" },
    .{ "Rumania", "Serbia" },
    .{ "Greece", "Albania" },
    .{ "Greece", "Serbia" },
    .{ "Serbia", "Albania" },
    .{ "Serbia", "Trieste" },
    .{ "Serbia", "Budapest" },
    .{ "Budapest", "Trieste" },
    .{ "Budapest", "Vienna" },
    .{ "Budapest", "Galicia" },
    .{ "Galicia", "Vienna" },
    .{ "Galicia", "Bohemia" },
    .{ "Galicia", "Silesia" },
    .{ "Silesia", "Bohemia" },
    .{ "Silesia", "Munich" },
    .{ "Silesia", "Berlin" },
    .{ "Silesia", "Prussia" },
    .{ "Prussia", "Berlin" },
    .{ "Berlin", "Kiel" },
    .{ "Berlin", "Munich" },
    .{ "Munich", "Kiel" },
    .{ "Munich", "Ruhr" },
    .{ "Munich", "Burgundy" },
    .{ "Munich", "Tyrolia" },
    .{ "Munich", "Bohemia" },
    .{ "Bohemia", "Tyrolia" },
    .{ "Bohemia", "Vienna" },
    .{ "Vienna", "Tyrolia" },
    .{ "Vienna", "Trieste" },
    .{ "Trieste", "Venice" },
    .{ "Trieste", "Tyrolia" },
    .{ "Kiel", "Ruhr" },
    .{ "Kiel", "Holland" },
    .{ "Ruhr", "Holland" },
    .{ "Holland", "Belgium" },
    .{ "Belgium", "Ruhr" },
    .{ "Belgium", "Burgundy" },
    .{ "Belgium", "Picardy" },
    .{ "Burgundy", "Ruhr" },
    .{ "Burgundy", "Marseilles" },
    .{ "Burgundy", "Gascony" },
    .{ "Burgundy", "Paris" },
    .{ "Burgundy", "Picardy" },
    .{ "Picardy", "Paris" },
    .{ "Picardy", "Brest" },
    .{ "Brest", "Gascony" },
    .{ "Brest", "Paris" },
    .{ "Gascony", "Paris" },
    .{ "Gascony", "Marseilles" },
    .{ "Gascony", "Spain" },
    .{ "Spain", "Portugal" },
    .{ "Spain", "Marseilles" },
    .{ "North Africa", "Tunis" },
    .{ "Marseilles", "Piedmont" },
    .{ "Piedmont", "Tuscany" },
    .{ "Piedmont", "Venice" },
    .{ "Piedmont", "Tyrolia" },
    .{ "Tuscany", "Venice" },
    .{ "Tuscany", "Rome" },
    .{ "Rome", "Venice" },
    .{ "Rome", "Apulia" },
    .{ "Rome", "Naples" },
    .{ "Naples", "Apulia" },
    .{ "Venice", "Tyrolia" },
};

const classic_supply_centers: []const dip_names.Name = &.{
    "Edinburgh",
    "London",
    "Liverpool",
    "Norway",
    "Sweden",
    "St. Petersburg",
    "Denmark",
    "Belgium",
    "Holland",
    "Kiel",
    "Berlin",
    "Munich",
    "Brest",
    "Paris",
    "Marseilles",
    "Portugal",
    "Spain",
    "Tunis",
    "Naples",
    "Rome",
    "Venice",
    "Trieste",
    "Vienna",
    "Budapest",
    "Serbia",
    "Greece",
    "Bulgaria",
    "Rumania",
    "Constantinople",
    "Ankara",
    "Smyrna",
    "Sevastopol",
    "Moscow",
    "Warsaw",
};

const classic_start: []const dip_names.CountryStart = &.{
    .{ .name = "England", .starting_units = &.{
        "Liverpool",
        "London Coast",
        "Edinburgh Coast",
    } },
    .{ .name = "France", .starting_units = &.{
        "Brest Coast",
        "Paris",
        "Marseilles",
    } },
    .{ .name = "Germany", .starting_units = &.{
        "Kiel Coast",
        "Berlin",
        "Munich",
    } },
    .{ .name = "Italy", .starting_units = &.{
        "Venice",
        "Rome",
        "Naples Coast",
    } },
    .{ .name = "Russia", .starting_units = &.{
        "St. Petersburg South Coast",
        "Moscow",
        "Warsaw",
        "Sevastopol Coast",
    } },
    .{ .name = "Austria", .starting_units = &.{
        "Vienna",
        "Budapest",
        "Trieste Coast",
    } },
    .{ .name = "Turkey", .starting_units = &.{
        "Constantinople",
        "Ankara Coast",
        "Smyrna",
    } },
};

const af_start: []const dip_names.CountryStart = &.{
    .{ .name = "France", .starting_units = &.{
        "Brest Coast",
        "Paris",
        "Marseilles",
    } },
    .{ .name = "Austria", .starting_units = &.{
        "Vienna",
        "Budapest",
        "Trieste Coast",
    } },
};

const classic_shortcuts: []const dip_names.Pair = &.{
    .{ "ADR", "Adriatic Sea" },
    .{ "AEG", "Aegean Sea" },
    .{ "BAL", "Baltic Sea" },
    .{ "BAR", "Barents Sea" },
    .{ "BLA", "Black Sea" },
    .{ "EAS", "Eastern Mediterranean Sea" },
    .{ "ENG", "English Channel" },
    .{ "BOT", "Gulf of Bothnia" },
    .{ "LYO", "Gulf of Lyon" },
    .{ "HEL", "Helgoland Bight" },
    .{ "ION", "Ionian Sea" },
    .{ "IRI", "Irish Sea" },
    .{ "MAO", "Mid-Atlantic Ocean" },
    .{ "NAO", "North Atlantic Ocean" },
    .{ "NTH", "North Sea" },
    .{ "NWG", "Norwegian Sea" },
    .{ "SKA", "Skagerrak" },
    .{ "TYS", "Tyrrhenian Sea" },
    .{ "WES", "Western Mediterranean Sea" },
    .{ "Alb", "Albania" },
    .{ "Alb(c)", "Albania Coast" },
    .{ "Apu", "Apulia" },
    .{ "Apu(c)", "Apulia Coast" },
    .{ "Ank", "Ankara" },
    .{ "Ank(c)", "Ankara Coast" },
    .{ "Arm", "Armenia" },
    .{ "Arm(c)", "Armenia Coast" },
    .{ "Bel", "Belgium" },
    .{ "Bel(c)", "Belgium Coast" },
    .{ "Ber", "Berlin" },
    .{ "Ber(c)", "Berlin Coast" },
    .{ "Boh", "Bohemia" },
    .{ "Bre", "Brest" },
    .{ "Bre(c)", "Brest Coast" },
    .{ "Bud", "Budapest" },
    .{ "Bul", "Bulgaria" },
    .{ "Bul(ec)", "Bulgaria East Coast" },
    .{ "Bul(sc)", "Bulgaria South Coast" },
    .{ "Bur", "Burgundy" },
    .{ "Cly", "Clyde" },
    .{ "Cly(c)", "Clyde Coast" },
    .{ "Con", "Constantinople" },
    .{ "Con(c)", "Constantinople Coast" },
    .{ "Den", "Denmark" },
    .{ "Den(c)", "Denmark Coast" },
    .{ "Edi", "Edinburgh" },
    .{ "Edi(c)", "Edinburgh Coast" },
    .{ "Fin", "Finland" },
    .{ "Fin(c)", "Finland Coast" },
    .{ "Gas", "Gascony" },
    .{ "Gas(c)", "Gascony Coast" },
    .{ "Gal", "Galicia" },
    .{ "Gre", "Greece" },
    .{ "Gre(c)", "Greece Coast" },
    .{ "Hol", "Holland" },
    .{ "Hol(c)", "Holland Coast" },
    .{ "Kie", "Kiel" },
    .{ "Kie(c)", "Kiel Coast" },
    .{ "Lon", "London" },
    .{ "Lon(c)", "London Coast" },
    .{ "Lvp", "Liverpool" },
    .{ "Lvp(c)", "Liverpool Coast" },
    .{ "Lvn", "Livonia" },
    .{ "Lvn(c)", "Livonia Coast" },
    .{ "Mar", "Marseilles" },
    .{ "Mar(c)", "Marseilles Coast" },
    .{ "Mos", "Moscow" },
    .{ "Mun", "Munich" },
    .{ "Nap", "Naples" },
    .{ "Nap(c)", "Naples Coast" },
    .{ "Nwy", "Norway" },
    .{ "Nwy(c)", "Norway Coast" },
    .{ "Par", "Paris" },
    .{ "Pic", "Picardy" },
    .{ "Pic(c)", "Picardy Coast" },
    .{ "Pie", "Piedmont" },
    .{ "Pie(c)", "Piedmont Coast" },
    .{ "Por", "Portugal" },
    .{ "Por(c)", "Portugal Coast" },
    .{ "Pru", "Prussia" },
    .{ "Pru(c)", "Prussia Coast" },
    .{ "Rom", "Rome" },
    .{ "Rom(c)", "Rome Coast" },
    .{ "Ruh", "Ruhr" },
    .{ "Naf", "North Africa" },
    .{ "Naf(c)", "North Africa Coast" },
    .{ "Rum", "Rumania" },
    .{ "Rum(c)", "Rumania Coast" },
    .{ "Ser", "Serbia" },
    .{ "Sil", "Silesia" },
    .{ "Sev", "Sevastopol" },
    .{ "Sev(c)", "Sevastopol Coast" },
    .{ "Smy", "Smyrna" },
    .{ "Smy(c)", "Smyrna Coast" },
    .{ "Spa", "Spain" },
    .{ "Spa(nc)", "Spain North Coast" },
    .{ "Spa(sc)", "Spain South Coast" },
    .{ "Stp", "St. Petersburg" },
    .{ "Stp(nc)", "St. Petersburg North Coast" },
    .{ "Stp(sc)", "St. Petersburg South Coast" },
    .{ "Swe", "Sweden" },
    .{ "Swe(c)", "Sweden Coast" },
    .{ "Syr", "Syria" },
    .{ "Syr(c)", "Syria Coast" },
    .{ "Tri", "Trieste" },
    .{ "Tri(c)", "Trieste Coast" },
    .{ "Tun", "Tunis" },
    .{ "Tun(c)", "Tunis Coast" },
    .{ "Tus", "Tuscany" },
    .{ "Tus(c)", "Tuscany Coast" },
    .{ "Tyr", "Tyrolia" },
    .{ "Ukr", "Ukraine" },
    .{ "Ven", "Venice" },
    .{ "Ven(c)", "Venice Coast" },
    .{ "Vie", "Vienna" },
    .{ "War", "Warsaw" },
    .{ "Wal", "Wales" },
    .{ "Wal(c)", "Wales Coast" },
    .{ "Yor", "Yorkshire" },
    .{ "Yor(c)", "Yorkshire Coast" },

};
