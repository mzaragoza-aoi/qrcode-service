class QrcodesController < ApplicationController
  def new
  end

  def show
    render_qrcode(params[:text])
  end

  def create
    render_qrcode(params[:text])
  end

  private

  def render_qrcode(text)
    svg = QrCodeGenerator.call(text)

    send_data svg,
      filename: "qrcode.svg",
      type: "image/svg+xml",
      disposition: "inline"
  rescue QrCodeGenerator::Error => e
    respond_to do |format|
      format.html do
        flash.now[:alert] = e.message
        render :new, status: :unprocessable_entity
      end
      format.any { render plain: e.message, status: :unprocessable_entity }
    end
  end
end
