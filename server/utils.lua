function Response(isSuccess, errorMessage, data)
  if not isSuccess then
    return {
      status = "error",
      data = errorMessage
    }
  end
  return {
    status = "success",
    data = data
  }
end
