module Trestle
  module Auth
    module ControllerMethods
      extend ActiveSupport::Concern

      included do
        helper_method :current_user, :logged_in?

        before_action :require_authenticated_user
        around_action :set_locale
      end

    protected
      def current_user
        @current_user ||= begin
          if session[:trestle_user]
            Trestle.config.auth.user_scope.find(id: session[:trestle_user])
          elsif Trestle.config.auth.remember.enabled && token = cookies.signed[:trestle_remember_token]
            user = Trestle.config.auth.remember.authenticate(token)
            login!(user) if user
            user
          end
        end
      end

      def login!(user)
        session[:trestle_user] = user.id
        @current_user = user
      end

      def logout!
        forget_me!
        session.delete(:trestle_user)
        @current_user = nil
      end

      def logged_in?
        !!current_user
      end

      def store_location
        session[:trestle_return_to] = request.fullpath
      end

      def previous_location
        session.delete(:trestle_return_to)
      end

      def require_authenticated_user
        logged_in? || login_required!
      end

      def login_required!
        store_location
        redirect_to trestle.login_url
        false
      end

      def remember_me!
        return unless Trestle.config.auth.remember.enabled
        Trestle.config.auth.remember.remember_me(current_user)
        cookies.signed[:trestle_remember_token] = Trestle.config.auth.remember.cookie(current_user)
      end

      def forget_me!
        return unless Trestle.config.auth.remember.enabled
        Trestle.config.auth.remember.forget_me(current_user) if logged_in?
        cookies.delete(:trestle_remember_token)
      end

      def set_locale
        self.locale = Trestle.config.auth.locale(current_user) || I18n.default_locale if logged_in?
        yield
      ensure
        self.locale = I18n.default_locale
      end
    end
  end
end
