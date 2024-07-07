現在 api の方は以下のようになっています。

```
// cors.rb
# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins = ['https://front-sigma-three.vercel.app']
    origins << ENV['API_DOMAIN'] if ENV['API_DOMAIN'].present?

    origins origins.compact.uniq

    resource '*',
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end
```

```
// devise_token_auth.rb
```

# frozen_string_literal: true

DeviseTokenAuth.setup do |config|
config.change_headers_on_each_request = false
config.token_lifespan = 2.weeks
config.token_cost = Rails.env.test? ? 4 : 10
config.enable_standard_devise_support = true
config.headers_names = {
'access-token': 'access-token',
client: 'client',
expiry: 'expiry',
uid: 'uid',
'token-type': 'token-type',
authorization: 'authorization'
}
end

```

```

// session_store.rb

# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
key: '\_app_session',
secure: Rails.env.production?,
httponly: true,
same_site: :none,
domain: :all

```

```

// production.rb

# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
config.cache_classes = true
config.eager_load = true
config.consider_all_requests_local = false
config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
config.active_storage.service = :local

ActionCable.server.config.disable_request_forgery_protection = true
config.action_cable.url = 'wss://demochat-api.fly.dev/cable'
config.action_cable.allowed_request_origins = ['https://front-sigma-three.vercel.app']

config.force_ssl = true
config.log_level = :debug
config.log_tags = [:request_id]
config.cache_store = :file_store, Rails.root.join('tmp/cache/').to_s
config.action_mailer.perform_caching = false
config.i18n.fallbacks = true
config.active_support.report_deprecations = false
config.log_formatter = Logger::Formatter.new

if ENV['RAILS_LOG_TO_STDOUT'].present?
logger = ActiveSupport::Logger.new($stdout)
logger.formatter = config.log_formatter
config.logger = ActiveSupport::TaggedLogging.new(logger)
end

config.active_record.dump_schema_after_migration = false

# CSRF 保護の設定

config.action_controller.allow_forgery_protection = false
config.action_controller.forgery_protection_origin_check = false

# CORS 設定

config.middleware.insert_before 0, Rack::Cors do
allow do
origins 'https://front-sigma-three.vercel.app'
resource '\*',
headers: :any,
methods: %i[get post put patch delete options head],
credentials: true
end
end

# ログの詳細設定

config.logger = Logger.new($stdout)
config.logger.level = Logger::DEBUG
end

```

front(Nuxt3)の現在の内容
```

// nuxt.config.ts
import { defineNuxtConfig } from "nuxt/config";

export default defineNuxtConfig({
css: ["@/assets/css/tailwind.css"],
devtools: { enabled: true },
plugins: ["~/plugins/axios.ts", "~/plugins/actioncable.ts"],
modules: ["@nuxtjs/tailwindcss"],
build: {
transpile: ["@nuxtjs/tailwindcss"],
},
runtimeConfig: {
public: {
NUXT_ENV_ENCRYPTION_KEY: process.env.NUXT_ENV_ENCRYPTION_KEY || "",
},
},
devServer: {
port: parseInt(process.env.FRONT_PORT || "8080"),
host: "0.0.0.0",
},
});

```

```

// plugins/axios.ts
import axios from "axios";
import { defineNuxtPlugin } from "#app";
import { useCookiesAuth } from "../composables/useCookiesAuth";

export default defineNuxtPlugin(() => {
const { saveAuthData } = useCookiesAuth();

const api = axios.create({
baseURL:
process.env.NODE_ENV === "production"
? "https://demochat-api.fly.dev"
: "http://localhost:3000",
withCredentials: true,
});

api.interceptors.response.use(
(response) => {
console.log(response);
return response;
},
(error) => {
console.log(error.response);
return Promise.reject(error);
}
);

return {
provide: {
axios: api,
},
};
});

```

```

// composables/useAuth.ts
import { ref } from "vue";
import { useNuxtApp } from "#app";
import { useCookiesAuth } from "./useCookiesAuth";
import { useRedirect } from "./useRedirect";

export const useAuth = () => {
const { $axios } = useNuxtApp();
const { saveAuthData, getAuthData } = useCookiesAuth();
const { redirectToChatroom } = useRedirect();

const errorMessage = ref("");
const successMessage = ref("");
const isLoading = ref(false);

const handleAuthResponse = (response: any) => {
console.log("Handling auth response", response);
if (response.status === 200 && response.data && response.headers) {
const authHeaders = {
"access-token": response.headers["access-token"],
client: response.headers["client"],
uid: response.headers["uid"],
expiry: response.headers["expiry"],
};
saveAuthData(authHeaders, response.data.data);
successMessage.value =
"認証に成功しました。チャットルームにリダイレクトします...";
setTimeout(() => {
redirectToChatroom();
}, 100);
} else {
console.error("Invalid auth response", response);
throw new Error("認証レスポンスが不正です");
}
};

const login = async (email: string, password: string) => {
console.log("Attempting login for:", email);
isLoading.value = true;
errorMessage.value = "";
successMessage.value = "";

    try {
      const response = await $axios.post(
        "/auth/sign_in",
        { email, password },
        {
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
          },
          withCredentials: true,
        }
      );
      handleAuthResponse(response);
    } catch (error: any) {
      console.error("Login error:", error);
      errorMessage.value =
        error.response?.data?.errors?.[0] || "ログインに失敗しました";
    } finally {
      isLoading.value = false;
    }

};

const signup = async (email: string, password: string, name: string) => {
console.log("Attempting signup for:", email);
isLoading.value = true;
errorMessage.value = "";
successMessage.value = "";

    try {
      const response = await $axios.post(
        "/auth",
        { email, password, name },
        {
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
          },
          withCredentials: true,
        }
      );
      handleAuthResponse(response);
    } catch (error: any) {
      console.error("Signup error:", error);
      errorMessage.value =
        error.response?.data?.errors?.[0] || "サインアップに失敗しました";
    } finally {
      isLoading.value = false;
    }

};

const logout = async () => {
isLoading.value = true;
errorMessage.value = "";
successMessage.value = "";

    try {
      const authData = getAuthData();
      await $axios.delete("/auth/sign_out", {
        headers: {
          "access-token": authData.token,
          client: authData.client,
          uid: authData.uid,
        },
        withCredentials: true,
      });
      // ログアウト後にCookieをクリア
      saveAuthData({}, null);
      successMessage.value = "ログアウトしました";
    } catch (error: any) {
      errorMessage.value = "ログアウトに失敗しました";
      console.error("ログアウトエラー:", error);
    } finally {
      isLoading.value = false;
    }

};

return {
login,
signup,
logout,
errorMessage,
successMessage,
isLoading,
};
};

```

```
