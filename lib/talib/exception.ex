defmodule NoDataError do
  defexception message: "no data error"
end

defmodule InsufficientDataError do
  defexception message: "insufficient data error"
end
