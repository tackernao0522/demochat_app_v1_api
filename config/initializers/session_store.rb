# frozen_string_literal: true

Rails.application.config.session_store :cookie_store, key: '_app_session', secure: Rails.env.production?, httponly: true
