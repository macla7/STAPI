import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  createLikeAsync,
  fetchLikesAsync,
  destroyLikeAsync,
  initialState,
} from "../postSlice";
import { createNotificationBlueprint } from "../../notifications/notificationBlueprintAPI";

function Like(props) {
  const [currentUserLiked, setCurrentUserLiked] = useState(false);
  const post = useSelector((state) => {
    if (state.posts.posts.length > 0) {
      return getCurrentPostFromStore(state.posts.posts);
    }
    return initialState.posts[0];
  });
  const userId = useSelector((state) => state.sessions.user.id);
  const dispatch = useDispatch();
  const [numberOfLikes, setNumberOfLikes] = useState(0);

  let likeDetails = {
    post_id: props.post.id,
    user_id: userId,
  };

  function action(e) {
    e.preventDefault();
    if (!currentUserLiked) {
      likePost();
    } else {
      unlikePost();
    }
  }

  function likePost() {
    setCurrentUserLiked(true);
    dispatch(createLikeAsync(likeDetails));
    createNotification();
  }

  function unlikePost() {
    setCurrentUserLiked(false);
    dispatch(destroyLikeAsync(likeDetails));
  }

  function createNotification() {
    let notification_blueprint = {
      notificationable_type: "Post",
      notificationable_id: props.post.id,
      notification_type: 7,
    };
    createNotificationBlueprint(notification_blueprint);
  }

  // Fetch Likes
  useEffect(() => {
    setNumberOfLikes(post.likes.length);
    hasCurrentUserLiked();
  }, [post.likes.length, dispatch]);

  function hasCurrentUserLiked() {
    if (props.post.likes.filter((like) => like.user_id === userId).length > 0) {
      setCurrentUserLiked(true);
    }
  }

  function getCurrentPostFromStore(posts) {
    if (posts !== undefined) {
      let filteredPost = posts.filter((post) => post.id === props.post.id);
      if (filteredPost.length > 0) {
        return filteredPost[0];
      }
    }
    return initialState.posts[0];
  }

  return (
    <p>
      <button onClick={(e) => action(e)}>Like</button>
      #Likes: {numberOfLikes}
      {currentUserLiked ? " (Liked)" : ""}
    </p>
  );
}

export default Like;
