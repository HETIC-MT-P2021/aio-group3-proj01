defmodule ApiApp.ImageHandler do
  use Waffle.Definition

  @versions [:original, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  def acl(:thumb, _), do: :public_read

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  def filename(version, _) do
    version
  end
end
