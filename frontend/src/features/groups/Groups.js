import React, { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import GroupForm from "./GroupForm";
import {
  fetchGroupsAsync,
  selectGroups,
  selectStatus,
  Statuses,
  updateGroupAsync,
  setGroup,
} from "./groupSlice";
import { selectUserId, selectIsLoggedIn } from "../sessions/sessionSlice";
import { Link } from "react-router-dom";
import { createInviteAsync } from "./invites/inviteSlice";
import { createNotificationBlueprint } from "../notifications/notificationBlueprintAPI";

function Groups() {
  const groups = useSelector(selectGroups);
  const status = useSelector(selectStatus);
  const userId = useSelector(selectUserId);
  const isLoggedIn = useSelector(selectIsLoggedIn);
  const dispatch = useDispatch();

  // Called on initialise, because dispatch changes (on intialise)
  // and on groups.length change
  useEffect(() => {
    if (isLoggedIn) {
      dispatch(fetchGroupsAsync());
    }
  }, [dispatch, groups.length, isLoggedIn]);

  let listOfGroups;
  if (groups && groups.length > 0) {
    listOfGroups = groups.map((group) => {
      return (
        <div
          key={group.id}
          style={{ margin: "5em" }}
          onClick={() => dispatch(setGroup(group.id))}
        >
          <Link to={`/groups/${group.id}`}>{group.name}</Link>
          <button onClick={() => requestToJoinGroup(group.id)}>Join</button>
        </div>
      );
    });
  } else {
    listOfGroups = "";
  }

  let contents;
  if (status !== Statuses.UpToDate) {
    contents = <div>{status}</div>;
  } else {
    contents = (
      <div className="card">
        <div className="card-body">
          <h3>{status}</h3>
          <GroupForm />
          {listOfGroups}
        </div>
      </div>
    );
  }

  function requestToJoinGroup(groupId) {
    let inviteDetails = {
      group_id: groupId,
      internal_user_id: null,
      external_user_id: userId,
      request: true,
    };

    dispatch(createInviteAsync(inviteDetails));

    // if above succeeds ..?
    let notification_blueprint = {
      notificationable_type: "Group",
      notificationable_id: groupId,
      notification_type: 3,
    };

    createNotificationBlueprint(notification_blueprint);
  }

  return (
    <div>
      <h1>Groups</h1>
      {contents}
    </div>
  );
}

export default Groups;
