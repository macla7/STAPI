import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { initialState } from "../postSlice";

function Shift(props) {
  const post = useSelector((state) => {
    if (state.posts.posts.length > 0) {
      return getCurrentPostFromStore(state.posts.posts);
    }
    return initialState.posts[0];
  });
  const [shiftsList, setShiftsList] = useState("");
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

  function listShifts(shifts) {
    return shifts.map((shift) => (
      <li key={shift.id}>
        <p>
          Shift: {shift.id} - Position: {shift.position}
        </p>
        <p>Description: {shift.description}</p>
        <p>
          Time: {shift.start} -{">"} {shift.end}
        </p>
      </li>
    ));
  }

  useEffect(() => {
    setShiftsList(listShifts(post.shifts));
  }, [post.shifts.length, dispatch]);

  return (
    <div>
      Shifts:
      <ul>{shiftsList}</ul>
    </div>
  );
}

export default Shift;
