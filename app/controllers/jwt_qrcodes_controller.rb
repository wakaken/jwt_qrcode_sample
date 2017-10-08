require 'jwt'
require 'rqrcode_png'

class JwtQrcodesController < ApplicationController
  protect_from_forgery with: :exception, except: [:update]

  def show
    data = "some data used by someone who scanned a QR Code."
    data_digest_with_random_hex = Digest::SHA256.hexdigest(data) + SecureRandom.hex(16)
    now = Time.now.to_i

    jwt_data = {
      iss: 'Jwt-Qrcode-Sample',
      iat: now,
      exp: now + 300,
      data: data_digest_with_random_hex
    }

    private_key = OpenSSL::PKey::RSA.new(File.read('ssh/id_rsa_jwt_qrcode_sample'))
    jwt = JWT.encode jwt_data, private_key, 'RS256'
    JwtQrcode.new(jwt: jwt, data: data).save!
    @jwt_text_qrcode = RQRCode::QRCode.new(jwt, level: 'l').to_img.resize(250, 250).to_data_url
  end

  def update
    jwt = params[:jwt]
    public_key = OpenSSL::PKey::RSA.new(File.read('ssh/id_rsa_jwt_qrcode_sample.pub'))

    begin
      JWT.decode jwt, public_key, true, { algorithm: 'RS256' }
    rescue JWT::ExpiredSignature => err
      render json: { status: 'error', detail: err.to_s } and return
    rescue JWT::VerificationError => err
      render json: { status: 'error', detail: err.to_s } and return
    end

    jwt_qrcode = JwtQrcode.find_by_jwt(jwt)

    if jwt_qrcode.user_id
      render json: { status: 'error', detail: 'This QR Code has already been scanned.' } and return
    end

    if jwt_qrcode.update(user_id: params[:user_id])
      render json: { status: 'ok' }
    else
      render json: { status: 'error', detail: 'user_id updating error.' }
    end
  end
end
