module UserHelper

  ROLES_OPTIONS = Array[*User::ROLES.collect {|v,i| [v.titleize,v] }]

end
