module ApplicationHelper
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def scheduler_modes
    ['On Demand', 'Daily', 'Weekly', 'Monthly']
  end

  def days_of_week
    [['Monday',1], ['Tuesday',2], ['Wednesday',3], ['Thursday',4], ['Friday',5], ['Saturday',6], ['Sunday',7]]
  end

  def days_of_month
     new_array = []
     (1..28).each {|x| new_array << [x.ordinalize + ' day', x]}
     new_array
  end

  def days_for_select(mode)
    return days_of_week if mode == 'Weekly'
    days_of_month
  end

  def position_change(change)
    changed_value = change.blank? ? 0 : change.to_i
    if changed_value == 0
      return ""
    elsif changed_value > 0
      return ("<img src='/images/up.gif' class='arrow'>" + '&nbsp;+' + change + '&nbsp;').html_safe
    else
      return ("<img src='/images/down.gif' class='arrow'>" + '&nbsp;' + change + '&nbsp;').html_safe
    end
  end

  def render_report(hash_args = {})
    rg  = hash_args[:report_group]
    rep = hash_args[:report]
    r   = rep.prepare

    html = ''
    html << "<table><tr><td><span id='selected_report_group'>#{link_to rg.name, last_report_user_report_group_path(rg.user_id, rg)}</span><br/>"
    html << "<span id='selected_report'>#{h rep.updated_at} (#{time_ago_in_words(rep.updated_at)} ago)</span><br/>"
    html << "Status:&nbsp; <span id='selected_report_status'>#{h rep.status}</span><br/>"
    html << "</td></tr><tr><td id='report_items' valign='top'>"
    for site in r['data'].keys
      html << "<table class='table-main'><tr class='table-header'><th>#{h site}</th>"
      for column in r['columns']
        html << "<td>#{h column}</td>"
      end
      html << "</tr>"
      for keyword in r['rows']
        html << "<tr class='#{cycle('list-line-odd','list-line-even')}'><td>#{h keyword}</td>"
        for search_engine in r['columns']
          html << "<td align='center'>#{link_to r['data'][site][keyword][search_engine]['position'], graph_user_report_group_path(:user_id => rg.user_id, :id => rg.id, :site_url => site, :keyword => keyword, :search_engine => search_engine)}"
          html << position_change(r['data'][site][keyword][search_engine]['position_change'])
          unless r['data'][site][keyword][search_engine]['position_best'].empty?
            html << "&nbsp;&nbsp;<span style='color: green;'>#{h r['data'][site][keyword][search_engine]['position_best']}</span>"
          end
          html << "</td>"
        end
        html << "</tr>"
      end
      html << "</table><br/>"
    end unless r.blank?
    html << "</td></tr></table>"
    html.html_safe
  end

end
  
