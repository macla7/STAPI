import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  fetchMyGroupsAsync,
  selectMyGroups,
  setGroupSearchId,
} from "./groupSlice";

function GroupSearch(props) {
  const groups = useSelector(selectMyGroups);
  const [groupList, setGroupList] = useState("");
  const dispatch = useDispatch();
  const [groupSearchQuery, setGroupSearchQuery] = useState("");

  function filterGroups(groups, groupSearchQuery = null) {
    if (!groupSearchQuery) {
      return groups;
    }
    groupSearchQuery = groupSearchQuery.toLowerCase();

    return groups.filter((group) => {
      let groupName = group.name.toLowerCase();
      return groupName.includes(groupSearchQuery);
    });
  }

  function handleClick(group) {
    setGroupSearchQuery(group.name);
    dispatch(setGroupSearchId(group.id));
  }

  function listGroups(groups) {
    setGroupList(
      groups.map((group) => (
        <li key={group.id} onClick={(e) => handleClick(group)}>
          {group.name}
        </li>
      ))
    );
  }

  // Members
  useEffect(() => {
    dispatch(fetchMyGroupsAsync());
  }, [dispatch]);

  useEffect(() => {
    listGroups(filterGroups(groups, groupSearchQuery));
  }, [groups, groupSearchQuery]);

  return (
    <div>
      <label>
        Group:
        <input
          type="email"
          name="email"
          placeholder="Search groups .."
          value={groupSearchQuery}
          onChange={(e) => setGroupSearchQuery(e.target.value)}
        />
      </label>
      <div>{groupList}</div>
    </div>
  );
}

export default GroupSearch;
