defmodule ApiAppWeb.ErrorView do
  use ApiAppWeb, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "Endpoint not found!"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error!"}}
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
