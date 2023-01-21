import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  updateInviteAsync,
  fetchRequestsAsync,
  selectRequests,
  updateRequestAsync,
} from "./inviteSlice";
import { createMembershipAsync } from "../memberships/membershipSlice";

function Requests(props) {
  const userId = useSelector((state) => state.sessions.user.id);
  const requests = useSelector(selectRequests);

  const [requestsList, setRequestsList] = useState("");
  const dispatch = useDispatch();

  function listRequests(requestees) {
    return requestees.map((requestee) => (
      <li key={requestee.external_user_id}>
        {requestee.external_user_id}{" "}
        <button
          onClick={() =>
            handleAcceptRequest(requestee.external_user_id, requestee.id)
          }
        >
          Accept
        </button>
      </li>
    ));
  }

  function handleAcceptRequest(externalUserId, inviteId) {
    // create membership
    let membershipDetails = {
      group_id: props.groupId,
      user_id: externalUserId,
      role: 1,
      status: 0,
    };
    dispatch(createMembershipAsync(membershipDetails));
    // update invite
    let invite = {
      inviteDetails: {
        accepted: true,
        internal_user_id: userId,
      },
      id: inviteId,
      group_id: props.groupId,
    };
    dispatch(updateRequestAsync(invite));
  }

  // Requests
  useEffect(() => {
    dispatch(fetchRequestsAsync(props.groupId));
  }, [dispatch, userId, props.groupId, requests.length]);

  useEffect(() => {
    setRequestsList(listRequests(requests));
  }, [requests]);

  return (
    <div>
      <h2>Requests</h2>
      <ul>{requestsList}</ul>
    </div>
  );
}

export default Requests;
