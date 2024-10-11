
# Diplomacy Adjudicator

DATC-compliant implementation of board game Diplomacy with a CLI demo showing example usage.


## Usage

Supported Zig version is 0.13.0. To build demo, run `zig build`. Tests can be run with `zig build test`.

If you want to use adjudicator in your project, just copy `dip.zig` optionally with `dip_names.zig` and `dip_memory.zig` to your project.

To simply play the demo, download the executable from releases.

## Features

- Highly customizable options of adjudication and order acceptance. Deal with illegal orders and convoy moves however you want. Can fully imitate Backstabbr and WebDiplomacy logic.[*citation needed*]
- Ability to see all possible legal orders for the given unit.
- Simple sandboxing support. Add/remove units. Change supply center's owner.
- Can provide detailed reason for rejection of illegal orders.
- Adding map-based variant should be pretty easy. Already includes **Classic** and **Austria vs France**.
- Ability to adress provinces with short and long names. Possibility of adding custom shortcut names.

## Limitations

- No ability to rollback the game to previous timestamp.
- No ability to save/load board state.
- Demo requires very strict formatting for accepting orders.
- No way to produce image of the game state.

## Structure

 - `dip.zig` - Contains everything required to play Diplomacy and a little more.
 - `dip_names.zig` - Allows creating and interacting with game using strings.
 - `dip_memory.zig` - Allows storing the information about past board states.
 - `classic.zig` - Data required to setup the map and units for a classic game.
 - `datc.zig` - Tests of adjudication logic. See [DATC](https://www.webdiplomacy.net/doc/DATC_v3_0.html#6)
 - `datc_my.zig` - Not enough of additional tests more closely related to this particular implementation.
 - `demo.zig` - CLI demo.

## Examples from demo

### Options.

```
>.options
missing_orders            = throw_error
illegal_commands          = throw_error
illegal_retreats          = throw_error
duplicate_orders          = throw_error
extra_builds              = throw_error
adapt_area                = adapt
move_to_convoy            = never
move_to_self_is_hold      = false
infer_convoy_intent       = false
convoy_can_fallback       = false

>.info adapt_area
How to adapt land<->coast provinces in orders.
On "adapt" F Mar - Spa turns into F Mar(c) - Spa(sc).
On "adapt_across_coasts" F Mar - Spa(nc) turns into F Mar(c) - Spa(sc).
Possible values:
-ignore
-adapt
-adapt_across_coasts

>.set convoy_can_fallback true
```

### Sandbox.

```
>.sandbox

>>.create MAO - Austria

>>.create F Greece - Austria

>>.set mos  - france

>>.create F StP - France
You need to specify the coast of "St. Petersburg".

>>.units

France:
          F Brest Coast
          A Paris
          A Marseilles

Austria:
          A Vienna
          A Budapest
          F Trieste Coast
          F Mid-Atlantic Ocean
          F Greece Coast
```

### Error reporting.

```
// illegal_commands = throw_error //

>.order Austria

Austria>>.units

Austria:
          A Vienna
          A Budapest
          F Trieste Coast
          F Mid-Atlantic Ocean
          F Greece Coast

Austria>>mao - spa
More than one coast is available, specify one.

Austria>>tri s vie - tyr
Unit at "Trieste" can't support to "Tyrolia".

Austria>>Paris - Burgundy
Unit at "Paris" is of another country.

Austria>>Vienna - Munich
There is no path between "Vienna" and "Munich".
```

### Builds.

```
>.adjudicate
No retreats needed, transitioning to winter.
1901 Winter

France:
1 builds left.
          F Spa(nc)
          A Bur
          A Tyr

Austria:
2 builds left.
          A Mun
          A Bud
          F Gre(c)

>.order

>>.legal

France:
1 builds left.
          Bre
          Par
          Mar

Austria:
2 builds left.
          Tri
          Vie

>>b F Brest

>>b A vie

>>.legal

France:
No orders available.

Austria:
1 builds left.
          Tri
          Vie b A
```

### Retreats.

```
// illegal_commands = treat_as_hold //

>.adjudicate
1902 Spring retreats

France:
          F Spa(nc) - Por(c) [SUCCEEDED]
          A Bur s Tyr - Mun [SUCCEEDED]
          A Tyr - Mun [SUCCEEDED]
          F Bre(c) - ENG [SUCCEEDED]

Austria:
Dislodged A Mun - Tyr [FAILED]
          A Bud - War [ILLEGAL]
          F Gre(c) - ION [SUCCEEDED]
          A Vie - Tri [SUCCEEDED]

>.order Austria

Austria>>.legal Mun

          Mun d
          Mun - Sil
          Mun - Ber
          Mun - Kie
          Mun - Ruh
          Mun - Boh

Austria>>Munich - Berlin

Austria>>.units

Austria:
Dislodged A Mun - Tyr [FAILED]
               (Retreats to Ber)
          A Bud - War [ILLEGAL]
          F Gre(c) - ION [SUCCEEDED]
          A Vie - Tri [SUCCEEDED]
```

### Remembering.

```
// illegal_commands = treat_as_hold //

>.remember 1902 spring

France:
          F Spa(nc) - Por(c) [SUCCEEDED]
          A Bur s Tyr - Mun [SUCCEEDED]
          A Tyr - Mun [SUCCEEDED]
          F Bre(c) - ENG [SUCCEEDED]

Austria:
Dislodged A Mun - Tyr [FAILED]
               (Retreats to Ber) [SURVIVED]
          A Bud - War [ILLEGAL]
          F Gre(c) - ION [SUCCEEDED]
          A Vie - Tri [SUCCEEDED]
```

### Legal moves.

```
// convoy_can_fallback = true //

>.order

>>.units

France:
          F Por(c)
          A Bur
          A Mun
          F ENG

Austria:
          A Ber
          A Bud
          F ION
          A Tri
          F ADR

>>.legal Adr c Tri

          ADR c Tri - Alb
          ADR c Tri - Apu
          ADR c Tri - Gre
          ADR c Tri - Nap
          ADR c Tri - Tun
          ADR c Tri - Ven

>>.legal Mun s

          Mun s Bur h
          Mun s Bur - Ruh
          Mun s Ber h
          Mun s Ber - Sil
          Mun s Ber - Kie
          Mun s Tri - Tyr

>>.legal Por -

          Por(c) - MAO
          Por(c) - Spa(nc)
          Por(c) - Spa(sc)

>>.legal Tri c-

          Tri c- Alb
          Tri c- Apu
          Tri c- Bud
          Tri c- Gre
          Tri c- Nap
          Tri c- Ser
          Tri c- Tun
          Tri c- Tyr
          Tri c- Ven
          Tri c- Vie
```

## License

This project is licensed under the MIT license.
