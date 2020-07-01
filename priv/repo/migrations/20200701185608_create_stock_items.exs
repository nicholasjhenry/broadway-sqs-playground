defmodule BroadwaySqsPlayground.Repo.Migrations.CreateStockItems do
  use Ecto.Migration

  def change do
    create table(:stock_items) do
      add :sku, :string
      add :on_hand, :integer

      timestamps()
    end
  end
end
