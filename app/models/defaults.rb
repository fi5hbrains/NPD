# encoding: utf-8
class Defaults < ActiveRecord::Base
  SYSTEM_NAMES = %w(Gatekeeper Ghost)
  RESERVED_NAMES = %w(ads bottles maintenance vote autocomplete note get_invite admin administrator application assets bottles boxes brands catalogue comments delete destroy diary edit entries images index invites javascripts lab login logout moderator new notes polishes search session stylesheets tags update user_session users)
  PASS_DESSERT = %w(apple-pie baklava brownie charlotte cheesecake cinnamon-roll cookie cream-puff croissant eclair fudge gelato ice-cream macaroon marzipan pavlova pretzel pudding scone shortbread sorbet souffle syllabub tart tiramisu torte)
  PASS_COLOUR = %w(azure biege blue brown crimson green indigo orange pink purple red scarlet taupe teal violet yellow)
  LAYER = { particle_size: 50, particle_density: 25, opacity: 95 }
  MAGNETS = %w(d_stripes tree star hatch h_stripes)
  STACK_LIMIT = 200
  GLITTERS = %w(hexagon circle stick square star heart snow halfmoon rhombus)
  PER = {
    lab_polishes: 48
  }
  CANVAS = [305,572]
  BOTTLE = [128,186]

  COLOURS = {
    en: {
      'light'          => {h: 0..360,   s: 0..100,  l: 71..100},
      'dark'           => {h: 0..360,   s: 0..100,  l: 0..29},
      'pastel'         => {h: 0..360,   s: 0..29,   l: 50..90},
      'nude'           => {h: 10..40,   s: 35..60,  l: 50..80},
                       
      'black'          => {h: 0..360,   s: 0..100,  l: 0..8},
      'white'          => {h: 0..360,   s: 0..100,  l: 92..100},  
    
      'red'            => {h: 0..8,     s: 40..100, l: 8..60, h2: 338..360},
      'orange'         => {h: 6..45,    s: 40..100, l: 22..60},
      'yellow'         => {h: 45..62,   s: 40..100, l: 32..78},
      'green'          => {h: 61..151,  s: 20..100, l: 5..87},
      'aquamarine'     => {h: 145..171, s: 20..100, l: 5..75},
      'cyan'           => {h: 173..194, s: 20..100, l: 5..85},
      'blue'           => {h: 182..250, s: 30..100, l: 5..87},
      'indigo'         => {h: 200..255, s: 20..100, l: 10..65},
      'violet'         => {h: 255..290, s: 20..100, l: 5..80},
      'magenta'        => {h: 285..330, s: 20..100, l: 10..80},
      'pink'           => {h: 320..338, s: 50..100, l: 65..82},
      'hot pink'       => {h: 327..333, s: 80..100, l: 40..75},
      'rosewood'       => {h: 320..338, s: 30..100, l: 10..40},
                             
      'amber'          => {h: 25..49,   s: 55..100, l: 47..65},
      'azure'          => {h: 176..184, s: 75..100, l: 83..97},
      'beet'           => {h: 330..360, s: 94..100, l: 10..36},
      'biege'          => {h: 44..50,   s: 6..75,   l: 75..90},
      'brown'          => {h: 24..35,   s: 33..100, l: 9..26},
      'burnt umber'    => {h: 7..12,    s: 49..57,  l: 39..47},
      'cadmium yellow' => {h: 30..38,   s: 94..100, l: 47..58},
      'carmine'        => {h: 348..353, s: 80..100, l: 25..35},
      'carrot'         => {h: 30..38,   s: 75..95,  l: 45..60},
      'chartreuse'     => {h: 86..94,   s: 65..100, l: 40..60},
      'chestnut'       => {h: 7..13,    s: 64..100, l: 25..55}, 
      'cinnabar'       => {h: 8..20,    s: 64..100, l: 40..60},
      'cobalt'         => {h: 208..220, s: 70..100, l: 20..40},
      'coral'          => {h: 10..20,   s: 80..100, l: 35..65},
      'crimson'        => {h: 342..352, s: 70..100, l: 35..55},
      'deep pink'      => {h: 236..330, s: 90..100, l: 34..54},
      'emerald'        => {h: 135..145, s: 40..80,  l: 45..65},
      'firebrick'      => {h: 0..4,     s: 60..80,  l: 30..50, h2: 356..360},
      'flame'          => {h: 13..21,   s: 74..100, l: 45..60},
      'fuchsia'        => {h: 290..315, s: 65..100, l: 40..60},
      'grey'           => {h: 0..360,   s: 0..10,   l: 22..76},
      'ivory'          => {h: 56..64,   s: 80..100, l: 85..100},
      'khaki'          => {h: 42..56,   s: 40..60,  l: 25..43},
      'lavender'       => {h: 285..306, s: 26..100, l: 40..70},
      'lawn green'     => {h: 85..95,   s: 85..100, l: 32..55},
      'lilac'          => {h: 288..298, s: 60..70,  l: 70..85},
      'maroon'         => {h: 319..324, s: 94..100, l: 40..60},
      'melon'          => {h: 8..16,    s: 64..100, l: 75..90},
      'mint'           => {h: 125..151, s: 15..100, l: 55..85},
      'navy'           => {h: 236..243, s: 90..100, l: 15..35},
      'neon'           => {h: 0..360,   s: 91..100, l: 55..65},
      'olive'          => {h: 54..74,   s: 60..100, l: 17..50},
      'orchid'         => {h: 296..304, s: 50..70,  l: 50..70},
      'peach'          => {h: 17..35,   s: 65..100, l: 48..98},
      'peacock'        => {h: 293..299, s: 50..70,  l: 40..58},
      'pear'           => {h: 47..55,   s: 65..95,  l: 43..72},
      'jade'           => {h: 153..163, s: 65..100, l: 8..50},
      'lime'           => {h: 115..125, s: 70..100, l: 38..65},
      'blush'          => {h: 0..15,    s: 65..100, l: 83..92, h2: 329..360},
      'powder blue'    => {h: 182..192, s: 40..64,  l: 65..90},
      'pumpkin'        => {h: 13..29,   s: 60..100, l: 40..60}, 
      'purple'         => {h: 295..305, s: 75..100, l: 22..52},
      'raspberry'      => {h: 332..350, s: 75..100, l: 35..60},
      'rose'           => {h: 346..354, s: 75..100, l: 70..92},
      'rosy brown'     => {h: 0..6,     s: 20..42,  l: 50..80, h2: 356..360},
      'royal blue'     => {h: 220..229, s: 60..85,  l: 45..66},
      'ruby'           => {h: 340..360, s: 75..100, l: 28..40}, 
      'salmon'         => {h: 10..16,   s: 80..100, l: 60..75},
      'scarlet'        => {h: 4..12,    s: 85..100, l: 45..55},
      'sienna'         => {h: 30..38,   s: 75..100, l: 45..60},
      'signal orange'  => {h: 30..38,   s: 94..100, l: 45..60},
      'slate gray'     => {h: 200..220, s: 10..19,  l: 43..57},
      'steel blue'     => {h: 235..245, s: 35..50,  l: 50..70},
      'taupe'          => {h: 21..42,   s: 8..22,   l: 45..65},
      'teal'           => {h: 174..185, s: 70..100, l: 18..50},
      'terracotta'     => {h: 10..21,   s: 40..60,  l: 29..42}, 
      'thistle'        => {h: 296..304, s: 18..32,  l: 70..90},
      'tomato'         => {h: 343..353, s: 80..100, l: 30..50},
      'turquoise'      => {h: 158..186, s: 30..100, l: 10..80},
      'vermilion'      => {h: 6..14,    s: 75..100, l: 40..60}, 
      'blue violet'    => {h: 240..258, s: 30..50,  l: 43..63},
      'violet red'     => {h: 325..340, s: 70..100, l: 42..65},
      'medium purple'  => {h: 254..266, s: 50..90,  l: 55..75},
      'licorice'       => {h: 0..13,    s: 13..45,  l: 4..10},
      'lead'           => {h: 170..210, s: 2..10,   l: 44..56},
      'mauve'          => {h: 290..310, s: 40..80,  l: 50..70},
      'tungsten'       => {h: 202..242, s: 2..10,   l: 40..60},
      'steel'          => {h: 120..300, s: 0..4,    l: 65..85},
      'nickel'         => {h: 0..120,   s: 0..4,    l: 65..87, h2: 301..360},
      'aluminium'      => {h: 0..1, s: 1..2, l: 2..3},
      'magnesium'      => {h: 0..1, s: 1..2, l: 2..3},
      'silver'         => {h: 0..1, s: 1..2, l: 2..3},
      'mercury'        => {h: 0..1, s: 1..2, l: 2..3},
      'cayenne'        => {h: 348..360, s: 75..100, l: 60..68},
      'mocha'          => {h: 14..30,   s: 17..30,  l: 44..68},
      'asparagus'      => {h: 82..102,  s: 19..50,  l: 30..60},
      'eggplant'       => {h: 316..334, s: 12..55,  l: 6..34},
      'tangerine'      => {h: 28..38,   s: 75..100, l: 35..55},
      'lemon'          => {h: 57..63,   s: 60..100, l: 40..60},
      'blueberry'      => {h: 211..229, s: 65..100, l: 25..55},
      'strawberry'     => {h: 0..1, s: 1..2, l: 2..3},
      'grape'          => {h: 0..1, s: 1..2, l: 2..3},
      'cantaloupe'     => {h: 0..1, s: 1..2, l: 2..3},
      'banana'         => {h: 0..1, s: 1..2, l: 2..3},
      'carnation'      => {h: 0..1, s: 1..2, l: 2..3},
      'champagne'      => {h: 22..60, s: 30..90,  l: 84..94},
      'vinous'         => {h: 0..4,     s: 40..75,  l: 20..50, h2: 355..360}
    },
    ru: {
      'белый'             => {h: 0..360,   s: 0..100,  l: 95..100},
      'черный'            => {h: 0..360,   s: 0..100,  l: 0..6},
                          
      'красный'           => {h: 0..10, s: 50..100, l: 30..78, h2: 331..360},   
      'оранжевый'         => {h: 11..44,   s: 20..100, l: 5..95},
      'желтый'            => {h: 45..65,   s: 20..100, l: 5..95},
      'зеленый'           => {h: 66..144,  s: 20..100, l: 5..95},
      'аквамарин'         => {h: 145..171, s: 20..100, l: 5..95},
      'аквамариновый'     => {h: 145..171, s: 20..100, l: 5..95},
      'циан'              => {h: 173..194, s: 20..100, l: 5..95},
      'голубой'           => {h: 172..191, s: 20..100, l: 5..95},
      'синий'             => {h: 192..262, s: 20..100, l: 5..95},
      'фиолетовый'        => {h: 263..284, s: 20..100, l: 5..95},
      'маджента'          => {h: 285..330, s: 20..100, l: 5..95},
      'пурпурный'         => {h: 285..330, s: 20..100, l: 5..95},
                          
      'светлый'           => {h: 0..360,   s: 0..100,  l: 71..100},
      'темный'            => {h: 0..360,   s: 0..100,  l: 0..29},
      'пастель'           => {h: 0..360,   s: 0..29,   l: 50..90},
      'пастельный'        => {h: 0..360,   s: 0..29,   l: 30..70},
      'нюд'               => {h: 10..40,   s: 35..60,  l: 50..80},
      'телесный'          => {h: 10..40,   s: 35..60,  l: 50..80},    
                          
      'алый'              => {h: 6..10,    s: 94..100, l: 47..53},
      'бежевый'           => {h: 44..50,   s: 55..67,  l: 75..90},
      'бирюзовый'         => {h: 173..180, s: 47..90,  l: 35..65},
      'бордо'             => {h: 357..360, s: 40..52,  l: 22..50},
      'бордовый'          => {h: 357..360, s: 40..52,  l: 22..50},
      'вермильон'         => {h: 8..12,    s: 80..100, l: 43..58}, 
      'винный'            => {h: 357..360, s: 40..52,  l: 22..50},
      'грушевый'          => {h: 49..53,   s: 82..88,  l: 53..62},
      'жженая умбра'      => {h: 7..12,    s: 49..57,  l: 39..47},
      'изумрудный'        => {h: 137..143, s: 47..57,  l: 50..60},
      'индиго'            => {h: 273..277, s: 94..100, l: 22..29},
      'кармин'            => {h: 348..353, s: 90..100, l: 25..35},
      'карминовый'        => {h: 348..353, s: 90..100, l: 25..35},
      'каштановый'        => {h: 7..13,    s: 64..100, l: 30..55}, 
      'киноварь'          => {h: 8..20,    s: 70..100, l: 43..58},
      'кобальтовый'       => {h: 211..218, s: 94..100, l: 26..38},
      'коралловый'        => {h: 12..17,   s: 88..100, l: 35..65},
      'коричневый'        => {h: 24..35,   s: 68..100, l: 10..21},
      'лавындовый'        => {h: 237..243, s: 60..100, l: 70..90},
      'лазурный'          => {h: 208..212, s: 94..100, l: 47..53},
      'лазурь'            => {h: 208..212, s: 94..100, l: 47..53},
      'лаймовый'          => {h: 88..92,   s: 94..100, l: 47..53},
      'лиловый'           => {h: 337..343, s: 56..64,  l: 60..70},
      'малиновый'         => {h: 334..348, s: 75..100, l: 38..57},
      'морковный'         => {h: 30..38,   s: 80..95,  l: 47..58},
      'мятный'            => {h: 127..134, s: 86..96,  l: 80..90},
      'неоновый'          => {h: 0..360,   s: 91..100, l: 55..65},
      'оливковый'         => {h: 58..70,   s: 94..100, l: 20..35},
      'персиковый'        => {h: 20..38,   s: 85..100, l: 70..98},
      'розовый'           => {h: 348..352, s: 94..100, l: 75..90},
      'рубиновый'         => {h: 340..360, s: 75..100, l: 32..40}, 
      'салатовый'         => {h: 110..122, s: 94..100, l: 70..82},
      'свекольный'        => {h: 330..360, s: 94..100, l: 10..21},
      'серый'             => {h: 0..360,   s: 0..5,    l: 24..76},
      'сиена'             => {h: 30..38,   s: 80..95,  l: 47..58},
      'сине-зеленый'      => {h: 176..183, s: 75..100, l: 18..50},
      'сиреневый'         => {h: 287..304, s: 26..100, l: 40..70},
      'слоновой кости'    => {h: 58..62,  s: 94..100, l: 94..98},
      'тауп'              => {h: 21..42,   s: 9..20,   l: 50..62},
      'темно-синий'       => {h: 236..243, s: 94..100, l: 20..30},
      'терракотовый'      => {h: 10..21,   s: 40..60,  l: 29..42}, 
      'умбра жженая'      => {h: 7..12,    s: 49..57,  l: 39..47},
      'ультрамариновый'   => {},
      'аннато'            => {},
      'кадмий желтый'     => {},
      'кошениль'          => {},
      'цезальпиний'       => {},
      'изумрудно-зеленый' => {},
      'фуксиевый'         => {h: 298..302, s: 94..100, l: 47..53},
      'фуксия'            => {h: 298..302, s: 94..100, l: 47..53},
      'хаки'              => {h: 42..56,   s: 45..56,  l: 27..41},
      'ягодный'           => {h: 334..360, s: 75..100, l: 38..57},
      'янтарный'          => {h: 43..47,   s: 94..100, l: 47..53}
    }
  }
end
