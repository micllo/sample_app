class ApplicationController < ActionController::Base
  protect_from_forgery

  # 因为'Helper'（app/helpers）函数只能在view中使用
  # 所以需要引入一下，才能同时在controller中使用
  include SessionsHelper
  
end
