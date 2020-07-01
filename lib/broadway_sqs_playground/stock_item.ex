defmodule BroadwaySqsPlayground.StockItem do
  use Ecto.Schema

  schema "stock_items" do
    field(:sku, :string)
    field(:on_hand, :integer, default: 0)

    timestamps()
  end
end
