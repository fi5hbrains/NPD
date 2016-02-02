# encoding: utf-8
class Defaults < ActiveRecord::Base
  SYSTEM_NAMES = %w(Gatekeeper Ghost)
  RESERVED_NAMES = %w(vote autocomplete note get_invite admin administrator application assets bottles boxes brands catalogue comments delete destroy diary edit entries images index invites javascripts lab login logout moderator new notes polishes search session stylesheets tags update user_session users)
  PASS_DESSERT = %w(apple-pie baklava brownie charlotte cheesecake cinnamon-roll cookie cream-puff croissant eclair fudge gelato ice-cream macaroon marzipan pavlova pretzel pudding scone shortbread sorbet souffle syllabub tart tiramisu torte)
  PASS_COLOUR = %w(azure biege blue brown crimson green indigo orange pink purple red scarlet taupe teal violet yellow)
  LAYER = { particle_size: 50, particle_density: 25, opacity: 95 }
  MAGNETS = %w(d_stripes tree star hatch h_stripes)
  GLITTERS = %w(hexagon circle stick square star heart snow halfmoon rhombus)
  PER = {
    lab_polishes: 12
  }
  CANVAS = [305,572]
  BOTTLE = [128,186]
  COLOURS = {
    en: {
      'red'            => {h: 0..10, s: 50..100, l: 30..78, h2: 331..360},
      'orange'         => {h: 6..50,   s: 50..100, l: 5..95},
      'yellow'         => {h: 45..65,   s: 50..100, l: 5..95},
      'green'          => {h: 66..144,  s: 20..100, l: 5..95},
      'aquamarine'     => {h: 145..171, s: 20..100, l: 5..95},
      'blue'           => {h: 182..250, s: 30..100, l: 5..95},
      'indigo'         => {h: 200..262, s: 20..100, l: 5..95},
      'violet'         => {h: 263..284, s: 20..100, l: 5..95},
                       
      'light'          => {h: 0..360,   s: 0..100,  l: 71..100},
      'dark'           => {h: 0..360,   s: 0..100,  l: 0..29},
      'pastel'         => {h: 0..360,   s: 0..29,   l: 50..90},
      'nude'           => {h: 10..40,   s: 35..60,  l: 50..80},
                       
      'pear'           => {h: 49..53,   s: 82..88,  l: 53..62},
      'pink'           => {h: 348..353, s: 94..100, l: 70..81},
      'rose'           => {h: 348..352, s: 94..100, l: 75..90},
      'amber'          => {h: 43..47,   s: 94..100, l: 47..53},
      'scarlet'        => {h: 6..10,    s: 94..100, l: 47..53},
      'flame'          => {h: 15..19,   s: 74..80,  l: 48..54},
      'firebrick'      => {h: 0..2,     s: 65..71,  l: 39..45, h2: 358..360},
      'chartreuse'     => {h: 88..92,   s: 94..100, l: 47..53},
      'ivory'          => {h: 58..62,   s: 94..100, l: 94..98},
      'fuchsia'        => {h: 298..302, s: 94..100, l: 47..53},
      'crimson'        => {h: 344..350, s: 79..88,  l: 43..50},
      'cinnabar'       => {h: 8..20,    s: 70..100, l: 43..58},
      'violet red'     => {h: 330..336, s: 94..100, l: 47..65},
      'hot pink'       => {h: 327..333, s: 94..100, l: 55..75},
      'raspberry'      => {h: 334..348, s: 75..100, l: 38..57},
      'lavender'       => {h: 287..304, s: 26..100, l: 40..70},
      'deeppink'       => {h: 236..330, s: 94..100, l: 35..53},
      'maroon'         => {h: 319..324, s: 94..100, l: 40..60},
      'orchid'         => {h: 298..302, s: 54..65,  l: 50..70},
      'thistle'        => {h: 298..302, s: 20..28,  l: 75..85},
      'violet blue'     => {h: 268..373, s: 72..79,  l: 47..56},
      'navy'           => {h: 236..243, s: 94..100, l: 20..30},
      'cobalt'         => {h: 211..218, s: 94..100, l: 26..38},
      'royal blue'     => {h: 222..227, s: 68..79,  l: 50..64},
      'slate gray'     => {h: 200..220, s: 10..19,  l: 43..57},
      'steel blue'     => {h: 237..243, s: 39..48,  l: 54..67},
      'peacock'        => {h: 293..299, s: 55..65,  l: 45..53},
      'powder blue'    => {h: 184..190, s: 46..59,  l: 75..85},
      'mint'           => {h: 127..134, s: 86..96,  l: 80..90},
      'emerald'        => {h: 137..143, s: 47..57,  l: 50..60},
      'teal'           => {h: 176..183, s: 75..100, l: 18..50},
      'lawn green'     => {h: 87..93,   s: 94..100, l: 37..52},
      'olive'          => {h: 58..70,   s: 94..100, l: 20..35},
      'biege'          => {h: 44..50,   s: 55..67,  l: 75..90},
      'peach'          => {h: 20..38,   s: 85..100, l: 70..98},
      'khaki'          => {h: 42..56,   s: 45..56,  l: 27..41},
      'taupe'          => {h: 21..42,   s: 9..20,   l: 50..62},
      'cadmium yellow' => {h: 30..38,   s: 94..100, l: 47..58},
      'signal orange'  => {h: 30..38,   s: 94..100, l: 47..58},
      'carrot'         => {h: 30..38,   s: 80..95,  l: 47..58},
      'melon'          => {h: 28..25,   s: 64..74,  l: 50..60},
      'coral'          => {h: 12..17,   s: 88..100,  l: 35..65},
      'neon'           => {h: 0..360,   s: 91..100,  l: 55..65},
      'sienna'         => {h: 30..38,   s: 80..95,  l: 47..58},
      'burnt umber'    => {h: 7..12,    s: 49..57,  l: 39..47},
      'tomato'         => {h: 345..350, s: 90..98,  l: 30..50},
      'carmine'        => {h: 348..353, s: 90..100, l: 25..35},
      'salmon'         => {h: 11..15,   s: 90..100, l: 60..75},
      'brown'          => {h: 24..35,   s: 68..100, l: 10..21},
      'rosy brown'     => {h: 0..4,     s: 22..40,  l: 60..70, h2: 358..360},
      'purple'         => {h: 298..302, s: 94..100, l: 23..50},
      'gray'           => {h: 0..360,   s: 0..5,    l: 24..76},
      'white'          => {h: 0..360,   s: 0..100,  l: 95..100},
      'black'          => {h: 0..360,   s: 0..100,  l: 0..6},
      'lilac'          => {h: 290..296, s: 62..67,  l: 75..82},
      'vinous'         => {h: 357..360, s: 40..52,  l: 22..50},
      'wine'           => {h: 357..360, s: 40..52,  l: 22..50},
      'beet'           => {h: 330..360, s: 94..100, l: 10..21},
      'pumpkin'        => {h: 15..27,   s: 70..100, l: 43..58}, 
      'chestnut'       => {h: 7..13,    s: 64..100, l: 30..55}, 
      'ruby'           => {h: 340..360, s: 75..100, l: 32..40}, 
      'terracotta'     => {h: 10..21,   s: 40..60,  l: 29..42}, 
      'vermilion'      => {h: 8..12,    s: 80..100, l: 43..58}, 
    },
    ru: {
      'красный'       => {h: 0..10, s: 50..100, l: 30..78, h2: 331..360},   
      'оранжевый'     => {h: 11..44,   s: 20..100, l: 5..95},
      'желтый'        => {h: 45..65,   s: 20..100, l: 5..95},
      'зеленый'       => {h: 66..144,  s: 20..100, l: 5..95},
      'аквамарин'     => {h: 145..171, s: 20..100, l: 5..95},
      'аквамариновый' => {h: 145..171, s: 20..100, l: 5..95},
      'голубой'       => {h: 172..191, s: 20..100, l: 5..95},
      'синий'         => {h: 192..262, s: 20..100, l: 5..95},
      'фиолетовый'    => {h: 263..284, s: 20..100, l: 5..95},
      'magenta'       => {h: 285..330, s: 20..100, l: 5..95},
      'маджента'      => {h: 285..330, s: 20..100, l: 5..95},
      'пурпурный'     => {h: 285..330, s: 20..100, l: 5..95},
      
      'светлый'       => {h: 0..360,   s: 0..100,  l: 71..100},
      'темный'        => {h: 0..360,   s: 0..100,  l: 0..29},
      'пастель'       => {h: 0..360,   s: 0..29,   l: 50..90},
      'пастельный'    => {h: 0..360,   s: 0..29,   l: 30..70},
      'нюд'           => {h: 10..40,   s: 35..60,  l: 50..80},
      'телесный'      => {h: 10..40,   s: 35..60,  l: 50..80},    
  
      'грушевый'      => {h: 49..53,   s: 82..88,  l: 53..62},
      'розовый'       => {h: 348..352, s: 94..100, l: 75..90},
      'янтарный'      => {h: 43..47,   s: 94..100, l: 47..53},
      'алый'          => {h: 6..10,    s: 94..100, l: 47..53},
      'лаймовый'      => {h: 88..92,   s: 94..100, l: 47..53},
      'azure'         => {h: 178..182, s: 94..100, l: 85..97},
      'лазурный'      => {h: 208..212, s: 94..100, l: 47..53},
      'лазурь'        => {h: 208..212, s: 94..100, l: 47..53},
      'индиго'        => {h: 273..277, s: 94..100, l: 22..29},
      'слоновой кости' => {h: 58..62,  s: 94..100, l: 94..98},
      'фуксиевый'     => {h: 298..302, s: 94..100, l: 47..53},
      'фуксия'        => {h: 298..302, s: 94..100, l: 47..53},
      'киноварь'      => {h: 8..20,    s: 70..100, l: 43..58},
      'лавындовый'    => {h: 237..243, s: 60..100, l: 70..90},
      'малиновый'     => {h: 334..348, s: 75..100, l: 38..57},
      'ягодный'       => {h: 334..360, s: 75..100, l: 38..57},
      'темно-синий'   => {h: 236..243, s: 94..100, l: 20..30},
      'кобальтовый'   => {h: 211..218, s: 94..100, l: 26..38},
      'мятный'        => {h: 127..134, s: 86..96,  l: 80..90},
      'изумрудный'    => {h: 137..143, s: 47..57,  l: 50..60},
      'бирюзовый'     => {h: 173..180, s: 47..90,  l: 35..65},
      'сине-зеленый'  => {h: 176..183, s: 75..100, l: 18..50},
      'оливковый'     => {h: 58..70,   s: 94..100, l: 20..35},
      'бежевый'       => {h: 44..50,   s: 55..67,  l: 75..90},
      'персиковый'    => {h: 20..38,   s: 85..100, l: 70..98},
      'хаки'          => {h: 42..56,   s: 45..56,  l: 27..41},
      'тауп'          => {h: 21..42,   s: 9..20,   l: 50..62},
      'морковный'     => {h: 30..38,   s: 80..95,  l: 47..58},
      'неоновый'      => {h: 0..360,   s: 91..100,  l: 55..65},
      'коралловый'    => {h: 12..17,   s: 88..100,  l: 35..65},
      'сиена'         => {h: 30..38,   s: 80..95,  l: 47..58},
      'жженая умбра'  => {h: 7..12,    s: 49..57,  l: 39..47},
      'умбра жженая'  => {h: 7..12,    s: 49..57,  l: 39..47},
      'кармин'        => {h: 348..353, s: 90..100, l: 25..35},
      'карминовый'    => {h: 348..353, s: 90..100, l: 25..35},
      'коричневый'    => {h: 24..35,   s: 68..100, l: 10..21},
      'серый'         => {h: 0..360,   s: 0..5,    l: 24..76},
      'белый'         => {h: 0..360,   s: 0..100,  l: 95..100},
      'черный'        => {h: 0..360,   s: 0..100,  l: 0..6},
      'сиреневый'     => {h: 287..304, s: 26..100, l: 40..70},
      'лиловый'       => {h: 337..343, s: 56..64,  l: 60..70},
      'винный'        => {h: 357..360, s: 40..52,  l: 22..50},
      'бордовый'      => {h: 357..360, s: 40..52,  l: 22..50},
      'бордо'         => {h: 357..360, s: 40..52,  l: 22..50},
      'свекольный'    => {h: 330..360, s: 94..100, l: 10..21},
      'каштановый'    => {h: 7..13,    s: 64..100, l: 30..55}, 
      'рубиновый'     => {h: 340..360, s: 75..100, l: 32..40}, 
      'терракотовый'  => {h: 10..21,   s: 40..60,  l: 29..42}, 
      'вермильон'     => {h: 8..12,    s: 80..100, l: 43..58}, 
      'салатовый'     => {h: 110..122, s: 94..100, l: 70..82}
    }
  }
end