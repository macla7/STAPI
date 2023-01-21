import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import Like from "./likes/Like";
import Bid from "./bids/Bid.js";
import Shift from "./shifts/Shift.js";
import { initialState } from "./postSlice";
import { selectUsers } from "../users/userSlice";

function Post(props) {
  const [postInfo, setPostInfo] = useState("");
  const post = useSelector((state) => {
    if (state.posts.posts.length > 0) {
      return getCurrentPostFromStore(state.posts.posts);
    }
    return initialState.posts[0];
  });
  const [postor, setPostor] = useState("");

  function getCurrentPostFromStore(posts) {
    if (posts !== undefined) {
      let filteredPost = posts.filter((post) => post.id === props.post.id);
      if (filteredPost.length > 0) {
        return filteredPost[0];
      }
    }
    return initialState.posts[0];
  }

  useEffect(() => {
    setPostInfo(postInfoSection);
  }, [post.id]);

  function postInfoSection() {
    return (
      <div>
        <p>Post by {post.email}</p>
        <p>Group: {post.group_id}</p>
        <p>{post.body}</p>
        <p>Ends at: {post.ends_at}</p>
      </div>
    );
  }

  return (
    <div>
      {postInfo}
      <Like post={post} />
      <Bid post={post} />
      <Shift post={post} />
      <p>Comments</p>
    </div>
  );
}

export default Post;
