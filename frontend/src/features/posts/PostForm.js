import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import GroupSearch from "../groups/GroupSearch";
import postSlice, { createPostAsync } from "./postSlice";
import ShiftForm from "./shifts/ShiftForm";
import { selectGroupSearchId } from "../groups/groupSlice";
import { resetShifts } from "./shifts/shiftSlice";
import { createNotificationBlueprint } from "../notifications/notificationBlueprintAPI";

function PostForm(props) {
  const dispatch = useDispatch();
  const [body, setBody] = useState("");
  const [auction, setAuction] = useState("");
  const [endsAt, setEndsAt] = useState("");
  const shifts = useSelector((state) => state.shifts.shifts);
  const groupSearchId = useSelector(selectGroupSearchId);
  const [notice, setNotice] = useState("");

  function submitHandler(e) {
    let groupId = props.groupId ? props.groupId : groupSearchId;

    e.preventDefault();
    let post = {
      body: body,
      ends_at: endsAt,
      auction: auction,
      group_id: groupId,
      shifts_attributes: shifts,
    };
    dispatch(createPostAsync(post));

    // if above succeeds ..?
    let notification_blueprint = {
      notificationable_type: "Group",
      notificationable_id: groupId,
      notification_type: 4,
    };

    createNotificationBlueprint(notification_blueprint);
    resetState();
    dispatch(resetShifts());
  }

  function resetState() {
    setBody("");
    setAuction(true);
    setEndsAt("");
  }

  return (
    <div>
      <h1>Post Form</h1>
      <form>
        <ShiftForm post={props.post} />
        <br />
        {props.groupId ? "" : <GroupSearch />}
        <input
          type="datetime-local"
          name="endsAt"
          value={endsAt}
          onChange={(e) => setEndsAt(e.target.value)}
        ></input>
        <div onChange={(e) => setAuction(e.target.value)}>
          <input type="radio" id="notAuction" name="auction" value="true" />{" "}
          Fixed Price
          <input type="radio" id="auction" name="auction" value="false" />{" "}
          Auction
        </div>
        <textarea
          name="body"
          value={body}
          onChange={(e) => setBody(e.target.value)}
        />
        <button type="submit" onClick={(e) => submitHandler(e)}>
          Submit
        </button>
      </form>
    </div>
  );
}

export default PostForm;
