# frozen_string_literal: true

module Response
  def render_success(data, message = '成功しました')
    render json: { data:, message: }, status: :ok
  end

  def render_error(message = 'エラーが発生しました', errors = {}, status = :bad_request)
    render json: { message:, errors: }, status:
  end
end
