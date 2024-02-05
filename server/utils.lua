function Response(isSuccess, errorMessage, data)
  if not isSuccess then
    return {
      status = "error",
      data = errorMessage
    }
  end
  return {
    status = "ok",
    data = data
  }
end
