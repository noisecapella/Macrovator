module ActionTypesHelper
  def method_missing(meth, *args, &blk)
    # fix url helpers for views we don't provide
    if /_action_types_path$/ =~ meth
      url_for(:controller => :action_types)
    elsif /_action_type_path$/ =~ meth
      url_for(:controller => :action_types, :id => args[0].id, :action => :update)
    else
      super
    end
  end
end
