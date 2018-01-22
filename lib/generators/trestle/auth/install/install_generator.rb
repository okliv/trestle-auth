module Trestle
  module Auth
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "Installs trestle-auth"

        argument :model, type: :string, default: "Administrator"

        def insert_configuration
          inject_into_file "config/initializers/trestle.rb", before: /^end/ do
            <<-RUBY.strip_heredoc.indent(2)

              # == Authentication Options
              #
              # Specify the user class to be used by trestle-auth.
              #
              config.auth.user_class = -> { #{model} }

              # Specify the scope for valid admin users.
              # Defaults to config.auth.user_class (unscoped).
              #
              # config.auth.user_scope = -> { User.where(admin: true) }

              # Specify the Trestle admin for managing administrator users.
              #
              config.auth.user_admin = -> { :"auth/#{model.underscore.pluralize}" }

              # Specify the parameter (along with a password) to be used to
              # authenticate an administrator. Defaults to :email.
              #
              # config.auth.authenticate_with = :login

              # Customize the method for authenticating a user given login parameters.
              # The block should return an instance of the auth user class, or nil.
              #
              # config.auth.authenticate = ->(params) {
              #   User.authenticate(params[:login], params[:password])
              # }

              # Customize the rendering of user avatars. Can be disabled by setting to false.
              # Defaults to the Gravatar based on the user's email address.
              #
              # config.auth.avatar = ->(user) {
              #   image_tag(user.avatar_url, alt: user.name)
              # }

              # Customize the method for determining the user's locale.
              # Defaults to user.locale (if the method is defined).
              #
              # config.auth.locale = ->(user) {
              #   user.locale if user.respond_to?(:locale)
              # }

              # Customize the method for determining the user's time zone.
              # Defaults to user.time_zone (if the method is defined).
              #
              # config.auth.time_zone = ->(user) {
              #   user.time_zone if user.respond_to?(:time_zone)
              # }

              # Enable or disable remember me functionality. Defaults to true.
              #
              # config.auth.remember.enabled = false

              # Specify remember me expiration time. Defaults to 2 weeks.
              #
              # config.auth.remember.for = 30.days

              # Customize the method for authenticating a user given a remember token.
              #
              # config.auth.remember.authenticate = ->(token) {
              #   User.authenticate_with_remember_token(token)
              # }

              # Customize the method for finding a user given an ID from the session.
              #
              # config.auth.remember.find_user = ->(id) {
              #   User.find_by(id: id)
              # }

              # Customize the method for remembering a user.
              #
              # config.auth.remember.remember_me, ->(user) { user.remember_me! }

              # Customize the method for forgetting a user.
              #
              # config.auth.remember.forget_me, ->(user) { user.forget_me! }

              # Customize the method for generating the remember cookie.
              #
              # config.auth.remember.cookie, ->(user) {
              #   { value: user.remember_token, expires: user.remember_token_expires_at }
              # }
            RUBY
          end
        end

        def generate_model
          generate "trestle:auth:model", model
        end

        def generate_admin
          generate "trestle:auth:admin", model
        end
      end
    end
  end
end
