module ApplicationHelper
  include ColourMethods
  
  def is_owner
    current_user && current_user == @user
  end
  def to_link link
    link = 'http://' + link unless !link || link.blank? || link[/^http?:\/\//] || link[/^https?:\/\//]
    link_to link.sub('http://','').sub('https://','').split('/')[0], link
  end
  def set_section
    condition = false
    {
      'home' => {
        class: (current = params[:controller] == 'page') ? condition ||= 'current' : 'notCurrent',
        if: params[:action] != 'index' || !current,
        path: root_path
      },
      'diary' => {
        class: 'notCurrent inactive',
        if: false,
        path: ''
      },
      'catalogue' => {
        class: (current = !in_lab? && (params[:controller] == 'polishes' || params[:controller] == 'brands')) ? condition ||= 'current' : 'notCurrent',
        if: params[:controller] == 'brands' || params[:action] != 'index' || !current,
        path: catalogue_path
      },
      'personal' => {
        class: ((current = params[:controller] == 'users' && params[:action] == 'show') || params[:controller] == 'boxes') ? condition ||= 'current' : 'notCurrent',
        if: !current && current_user,
        path: current_user ? user_path(current_user) : ''
      },
      'settings' => (
        if current_user
          {
            class: (current = params[:controller] == 'users' && params[:action] == 'edit') ? condition ||= 'current' : 'notCurrent',
            if: !current,
            path: edit_user_path(current_user)
          }
        else 
          { class: 'hidden', if: false, path: '' }
        end 
      ),
      'lab' => {
        class: in_lab? ? condition ||= 'current' : current_user ? 'notCurrent' : 'notCurrent inactive',
        if: params[:action] != 'index' || !current,
        path: brands_path
      },
      'other' => {
        class: condition ? 'hidden' : condition ||= 'current' ,
        if: false
      }
    }
  end
  
  def set_nav_icons section
    current = section.detect{|k,v| v[:class] == 'current'}
    if current
      case current[0]
      when 'home'
        {
          'cup' => nil,
          'plant' => nil,
          'book' => nil,
          'faq' => nil,
        }
      when 'catalogue'
        {
          ((s = cookies[:polish_sort]) == 'slug desc' ? 'zA' : 'aZ') => [switch_path('polish_sort', (s == 'slug asc' ? 'slug desc' : 'slug asc')), !s || s =~ /slug/], 
          (s == 'rating asc' ? 'starsR' : 'stars') => [switch_path('polish_sort', (s == 'rating desc' ? 'rating asc' : 'rating desc')), s =~ /rating/] , 
          (s == 'comments_count asc' ? 'bubblesR' : 'bubbles') => [switch_path('polish_sort', (s == 'comments_count desc' ? 'comments_count asc' : 'comments_count desc')), s =~ /comments/], 
          (s == 'bottles asc' ? 'bottlesR' : 'bottles') => nil
        }
      when 'personal'
        {
          'portrait'  => true, 
          'puls'      => '', 
          'bigScroll' => '', 
          'bell'      => ''
        }
      when 'lab'
        {'101' => nil}
      when 'settings'
        {
          'frame'  => true, 
          'brush'  => '', 
          'wrench' => '', 
          'radio'  => ''
        }
      when 'other'
        {}
      end
    else
      {}
    end
  end
  
  def render_nav_icon icons, key
    svg_class = ''
    options = icons[key]
    if options.class.name == 'Array'
      link = options[0]
      is_active = options[1]
      id = options[2]
    else
      link = options
      is_active = (options == true)
    end
    svg_class = 'inactive' if icons[key] == nil
    svg_class = 'active' if is_active
    
    icon = content_tag :span, id: 'i_' + key, class: svg_class  do
      ''
    end

    if link.blank?
      icon
    else
      content_tag :a, icon, href: link, 'data-method' => :post, 'data-remote' => true, rel: "nofollow", class: 'navOption'
    end
    
  end
  
  def get_colour_names c
    c = colour_to_hsl(c)
    Defaults::COLOURS[I18n.locale].select do |k,v| 
      (v[:h].include?( c[0]) || (v[:h2].include?( c[0]) if v[:h2])) && 
      v[:s].include?( c[1]) && 
      v[:l].include?( c[2])
    end.keys
  end
end
