import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  createBidAsync,
  fetchBidsAsync,
  selectBids,
  initialState,
} from "../postSlice";
import { createNotificationBlueprint } from "../../notifications/notificationBlueprintAPI";

function Bid(props) {
  const post = useSelector((state) => {
    if (state.posts.posts.length > 0) {
      return getCurrentPostFromStore(state.posts.posts);
    }
    return initialState.posts[0];
  });
  const [priceDollars, setPriceDollars] = useState(0);
  const [priceCents, setPriceCents] = useState(0);
  const [bidNotice, setBidNotice] = useState("");
  const [bidsList, setBidsList] = useState("");
  const userId = useSelector((state) => state.sessions.user.id);
  const dispatch = useDispatch();

  function getCurrentPostFromStore(posts) {
    if (posts !== undefined) {
      let filteredPost = posts.filter((post) => post.id === props.post.id);
      if (filteredPost.length > 0) {
        return filteredPost[0];
      }
    }
    return initialState.posts[0];
  }

  function bidPost(e) {
    e.preventDefault();

    let bidDetails = {
      post_id: props.post.id,
      user_id: userId,
      price: getPriceMicroDollars(),
    };

    dispatch(createBidAsync(bidDetails));

    // if above succeeds ..?
    let notification_blueprint = {
      notificationable_type: "Post",
      notificationable_id: props.post.id,
      notification_type: 5,
    };
    let second_notification_blueprint = {
      notificationable_type: "Post",
      notificationable_id: props.post.id,
      notification_type: 6,
    };

    createNotificationBlueprint(notification_blueprint);
    createNotificationBlueprint(second_notification_blueprint);
  }

  function getPriceMicroDollars() {
    return (priceDollars * 100 + priceCents) * 10000;
  }

  function convertToInt(value) {
    return value ? parseInt(value) : "";
  }

  function listBids(bids) {
    return bids.map((bid) => (
      <li key={bid.id}>
        Bid: {bid.id} - Price: {bid.price}
      </li>
    ));
  }

  useEffect(() => {
    setBidsList(listBids(post.bids));
  }, [post.bids.length, dispatch]);

  return (
    <div>
      <form onSubmit={(e) => bidPost(e)}>
        <label>
          $:
          <input
            type="number"
            name="priceDollars"
            min="0"
            max="50"
            value={priceDollars}
            onChange={(e) => setPriceDollars(convertToInt(e.target.value))}
          />
        </label>
        <label>
          ¢:
          <input
            type="number"
            name="priceCents"
            min="0"
            max="100"
            value={priceCents}
            onChange={(e) => setPriceCents(convertToInt(e.target.value))}
          />
        </label>
        <input type="submit" value="Bid" />
      </form>
      <ul>{bidsList}</ul>
    </div>
  );
}

export default Bid;
