defmodule ChirpWeb.PostLive.PostComponent do
  use ChirpWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @post.id %>" class="post">
      <div class="row">
        <div class="column column-10">
          <div class="post-avatar">
            <img src="../images/avatar.svg">
          </div>
        </div>
        <div class="column column-90">
          <div class="post-body">
            <b>@<%= @post.username %></b>
            <br/>
            <%= @post.body %>
            <div class="column">
              <%= for url <- @post.photo_urls do %>
                <img src="<%= url %>" height="150" />
              <% end %>
            </div>
          </div>
        </div>
      </div>

      <div class="actions">
        <div class="row">
          <div class="column column-10">
            <div></div>
          </div>
          <div class="column column-20">
            <a href="#" phx-click="like" phx-target="<%= @myself %>">
              <i class="far fa-heart">Like</i> <%= @post.likes_count %>
            </a>
          </div>
          <div class="column column-50">
            <a href="#" phx-click="repost" phx-target="<%= @myself %>">
              <i class="far fa-hand-peace">Repost</i> <%= @post.reposts_count %>
            </a>
          </div>
          <div class="column">
            <%= live_patch to: Routes.post_show_path(@socket, :show, @post.id) do %>
              <i class="far fa-edit">Show</i>
            <% end %>
            <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
              <i class="far fa-edit">Edit</i>
            <% end %>
            <%= link to: "#", phx_click: "delete", phx_value_id: @post.id do %>
              <i class="far fa-trash-alt">Delete</i>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("like", _, socket) do
    Chirp.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end

  def handle_event("repost", _, socket) do
    Chirp.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
