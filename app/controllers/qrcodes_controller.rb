class QrcodesController < ApplicationController
  skip_forgery_protection only: :create

  def new
  end

  def show
    @text = params[:text].to_s
    @svg = QrCodeGenerator.call(@text)

    if raw_svg_request?
      send_svg(@svg)
    else
      render :result
    end
  rescue QrCodeGenerator::Error => e
    render plain: e.message, status: :unprocessable_entity
  end

  def create
    @text = params[:text].to_s
    @svg = QrCodeGenerator.call(@text)

    if preview_request?
      render :result
    else
      send_svg(@svg)
    end
  rescue QrCodeGenerator::Error => e
    if preview_request?
      flash.now[:alert] = e.message
      render :new, status: :unprocessable_entity
    else
      render plain: e.message, status: :unprocessable_entity
    end
  end

  private

  def send_svg(svg)
    send_data svg,
      filename: "qrcode.svg",
      type: "image/svg+xml",
      disposition: "inline"
  end

  def raw_svg_request?
    request.format.svg? || request.headers["Accept"].to_s.include?("image/svg+xml")
  end

  def preview_request?
    params[:preview].present?
  end
end
