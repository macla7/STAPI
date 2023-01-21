import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { fetchMembershipsAsync, selectMemberships } from "./membershipSlice";
import { isAdmin, isMember, isNotAdmin, isNotMember } from "../groupSlice";
import { selectIsLoggedIn } from "../../sessions/sessionSlice";

function Memberships(props) {
  const userId = useSelector((state) => state.sessions.user.id);
  const memberships = useSelector(selectMemberships);
  const [membershipsList, setMembershipsList] = useState("");
  const dispatch = useDispatch();
  const isLoggedIn = useSelector(selectIsLoggedIn);

  function listMemberships(members) {
    return members.map((member) => (
      <li key={member.user_id}>{member.user_id}</li>
    ));
  }

  // Members
  useEffect(() => {
    if (isLoggedIn) {
      if (props.groupId) {
        dispatch(fetchMembershipsAsync(props.groupId));
      }
    }
  }, [dispatch, userId, props.groupId, memberships.length, isLoggedIn]);

  useEffect(() => {
    setMembershipsList(listMemberships(memberships));
    let membersList = memberships.filter((member) => member.user_id === userId);
    let adminsList = membersList.filter((member) => member.role === "admin");
    if (membersList.length > 0) {
      dispatch(isMember());
      if (adminsList.length > 0) {
        dispatch(isAdmin());
      } else {
        dispatch(isNotAdmin());
      }
    } else {
      dispatch(isNotMember());
    }
  }, [dispatch, userId, memberships]);

  return (
    <div>
      {isLoggedIn ? (
        <div>
          <h2>Members</h2>
          <ul>{membershipsList}</ul>
        </div>
      ) : (
        ""
      )}
    </div>
  );
}

export default Memberships;
