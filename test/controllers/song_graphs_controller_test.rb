require 'test_helper'

class SongGraphsControllerTest < ActionController::TestCase
  setup do
    @song_graph = song_graphs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:song_graphs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create song_graph" do
    assert_difference('SongGraph.count') do
      post :create, song_graph: { from_music_id: @song_graph.from_music_id, song_weight: @song_graph.song_weight, to_music_id: @song_graph.to_music_id }
    end

    assert_redirected_to song_graph_path(assigns(:song_graph))
  end

  test "should show song_graph" do
    get :show, id: @song_graph
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @song_graph
    assert_response :success
  end

  test "should update song_graph" do
    patch :update, id: @song_graph, song_graph: { from_music_id: @song_graph.from_music_id, song_weight: @song_graph.song_weight, to_music_id: @song_graph.to_music_id }
    assert_redirected_to song_graph_path(assigns(:song_graph))
  end

  test "should destroy song_graph" do
    assert_difference('SongGraph.count', -1) do
      delete :destroy, id: @song_graph
    end

    assert_redirected_to song_graphs_path
  end
end
