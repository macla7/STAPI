
class AppVersionsController < ApplicationController
  def latest_version
    app_version = AppVersion.last
    render json: { version: app_version.version }
  end
end
