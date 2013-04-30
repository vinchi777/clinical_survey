module UserSurveysHelper

  def version_select_options(selected)
    options_for_select(['Week', 'Day'], selected)
  end

  def language_select_options(selected)
    options_for_select([['English','en'],['Dutch','nl'],['African','afr']], selected)
  end
end
