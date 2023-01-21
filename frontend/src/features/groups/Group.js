import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { Link, useParams } from "react-router-dom";

import { selectAdmin, selectMember } from "./groupSlice";
import Memberships from "./memberships/Memberships";
import Search from "../users/Search";

import Posts from "../posts/Posts";
import Requests from "./invites/Requests";

// Atm getting user through props so I can have it 'on mount' to determine
// admin status from memberships API. It doesn't seem to work
// if I try and grab from state.
function Group(props) {
  const userId = useSelector((state) => state.sessions.user.id);
  const isAdmin = useSelector(selectAdmin);
  const isMember = useSelector(selectMember);
  const dispatch = useDispatch();
  const [membersSection, setMembersSection] = useState();
  let params = useParams();

  useEffect(() => {
    createMembersSection();
  }, [isMember]);

  function createMembersSection() {
    if (isMember) {
      setMembersSection(
        <div>
          <Search groupId={params.groupId} />
          {isAdmin ? <Requests groupId={params.groupId} /> : ""}
          <Posts groupId={params.groupId}></Posts>
        </div>
      );
    } else {
      setMembersSection(
        <div>You need to be a member to see group details!</div>
      );
    }
  }

  return (
    <div>
      <h2>Group Details</h2>
      <p>Group id: {params.groupId}</p>
      <p>Admin: {isAdmin ? "true" : "false"}</p>
      <p>Member: {isMember ? "true" : "false"}</p>
      <p>User: {userId}</p>

      <div>
        <Memberships groupId={params.groupId} />

        {membersSection}
      </div>
    </div>
  );
}

export default Group;
