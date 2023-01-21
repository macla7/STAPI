import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  fetchPostsAsync,
  fetchPostsHomeAsync,
  selectPosts,
  selectStatus,
  Statuses,
  updatePostAsync,
} from "../posts/postSlice";
import Post from "../posts/Post";
import PostForm from "../posts/PostForm";
import { selectIsLoggedIn } from "../sessions/sessionSlice";

function Posts(props) {
  const userId = useSelector((state) => state.sessions.user.id);
  const [postsList, setPostsList] = useState("");
  const posts = useSelector(selectPosts);
  const status = useSelector(selectStatus);
  const isLoggedIn = useSelector(selectIsLoggedIn);
  const dispatch = useDispatch();

  // Posts
  useEffect(() => {
    if (isLoggedIn) {
      if (props.groupId) {
        dispatch(fetchPostsAsync(props.groupId));
      } else {
        dispatch(fetchPostsHomeAsync());
      }
    }
  }, [posts.length, props.groupId, isLoggedIn]);

  useEffect(() => {
    setPostsList(listPosts(posts));
  }, [posts.length, posts[0]]);

  let contents;
  if (!isLoggedIn) {
    contents = <h2>login to begin!</h2>;
  } else if (status !== Statuses.UpToDate) {
    contents = <div>{status}</div>;
  } else {
    contents = (
      <div className="card">
        <div className="card-body">
          <h1>Posts</h1>
          <h3>{status}</h3>
          <PostForm groupId={props.groupId} />
          {postsList}
        </div>
      </div>
    );
  }

  function listPosts(posts) {
    return posts.map((post) => (
      <div key={post.id} style={{ margin: "5em" }}>
        <Post dispatch={dispatch} post={post} />
      </div>
    ));
  }

  return (
    <div>
      <div>{contents}</div>
    </div>
  );
}

export default Posts;
