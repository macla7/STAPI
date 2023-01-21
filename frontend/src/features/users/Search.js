import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { fetchUsersAsync, selectUsers } from "./userSlice";
import { createInviteAsync } from "../groups/invites/inviteSlice";
import { createNotificationBlueprint } from "../notifications/notificationBlueprintAPI";

// Definitely coupled a bit too much with invite and group logic I think
function Search(props) {
  const userId = useSelector((state) => state.sessions.user.id);
  const users = useSelector(selectUsers);
  const [userList, setUserList] = useState("");
  const dispatch = useDispatch();
  const [searchQuery, setSearchQuery] = useState("");
  const [inviteNotice, setInviteNotice] = useState("");

  function attemptInvite(e) {
    e.preventDefault();

    if (validateEmail(searchQuery)) {
      inviteUser(findUserByEmail(searchQuery)[0]);
    } else {
      setInviteNotice(<p>Invite failed</p>);
    }
  }

  function inviteUser(user) {
    let inviteDetails = {
      group_id: props.groupId,
      internal_user_id: userId,
      external_user_id: user.id,
      request: false,
      accepted: false,
    };
    setInviteNotice(<p>Invited {user.email}</p>);
    dispatch(createInviteAsync(inviteDetails));

    // if above succeeds ..?
    let notification_blueprint = {
      notificationable_type: "Group",
      notificationable_id: props.groupId,
      notification_type: 1,
      recipient_id: user.id,
    };

    createNotificationBlueprint(notification_blueprint);
  }

  function filterUsers(users, searchQuery = null) {
    if (!searchQuery) {
      return users;
    }
    searchQuery = searchQuery.toLowerCase();

    return users.filter((user) => {
      let userEmail = user.email.toLowerCase();
      return userEmail.includes(searchQuery);
    });
  }

  function listUsers(users) {
    setUserList(
      users.map((user) => (
        <li key={user.id} onClick={(e) => setSearchQuery(user.email)}>
          {user.email}
        </li>
      ))
    );
  }

  function findUserByEmail(email) {
    return users.filter((user) => user.email === email);
  }

  function validateEmail(email) {
    return findUserByEmail(email).length === 1;
  }

  // Members
  useEffect(() => {
    dispatch(fetchUsersAsync());
  }, [dispatch]);

  useEffect(() => {
    listUsers(filterUsers(users, searchQuery));
  }, [users, searchQuery]);

  return (
    <div>
      <form onSubmit={(e) => attemptInvite(e)}>
        {inviteNotice ? inviteNotice : ""}
        <label>
          Email:
          <input
            type="email"
            name="email"
            placeholder="Search people..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </label>
        <input type="submit" value="Add" />
      </form>

      <div>{userList}</div>
    </div>
  );
}

export default Search;
