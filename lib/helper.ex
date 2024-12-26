defmodule Helper do
  def download!(url, save_as, overwrite? \\ false) do
    unless File.exists?(save_as) and not overwrite? do
      Req.get!(url, http_errors: :raise, into: File.stream!(save_as))
    end

    :ok
  end
end
