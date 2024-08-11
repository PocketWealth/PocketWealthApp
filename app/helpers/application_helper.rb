module ApplicationHelper
  def show_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end
  def delete_stock_path(stock)
    "/stocks/#{stock.id}/delete"
  end

  def transfer_stock_path(stock)
    "/stocks/#{stock.id}/transfer"
  end
end
