import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { initialState } from "../postSlice";
import {
  initialShiftState,
  createShift,
  deleteShift,
  resetShifts,
} from "./shiftSlice";

// Design is to be able to add multiple shifts to a post
function ShiftForm(props) {
  const [end, setEnd] = useState("");
  const [start, setStart] = useState("");
  const [description, setDescription] = useState("");
  const [position, setPosition] = useState("");
  const [shiftsList, setShiftsList] = useState("");
  const shifts = useSelector((state) => state.shifts.shifts);
  const dispatch = useDispatch();

  function createShiftsList(shifts) {
    return shifts.map((shift, i) => (
      <li key={i}>
        <p>Position: {shift.position}</p>
        <p>Description: {shift.description}</p>
        <p>Starts: {shift.start}</p>
        <p>Ends: {shift.end}</p>
      </li>
    ));
  }

  function formIsValid() {
    return datesMakeSense() && position;
  }

  // In the future AND sequential
  function datesMakeSense() {
    let startDateTime = new Date(start);
    let endDateTime = new Date(end);
    return (
      startDateTime.getTime() < endDateTime.getTime() &&
      startDateTime.getTime() > Date.now()
    );
  }

  useEffect(() => {
    setShiftsList(createShiftsList(shifts));
  }, [dispatch, shifts.length]);

  useEffect(() => {
    dispatch(resetShifts());
  }, []);

  function handleCreateShift(e) {
    e.preventDefault();
    if (formIsValid()) {
      let shift = {
        position: position,
        description: description,
        start: start,
        end: end,
      };
      dispatch(createShift(shift));
    }
  }

  return (
    <div>
      <label>
        Position:
        <input
          type="text"
          name="position"
          value={position}
          onChange={(e) => setPosition(e.target.value)}
        ></input>
      </label>
      <br />
      <label>
        Starts:
        <input
          type="datetime-local"
          name="end"
          value={start}
          onChange={(e) => setStart(e.target.value)}
        ></input>
      </label>
      <br />
      <label>
        Ends:
        <input
          type="datetime-local"
          name="ends"
          value={end}
          onChange={(e) => setEnd(e.target.value)}
        ></input>
      </label>
      <br />
      <label>
        Description:
        <textarea
          name="description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
        />
      </label>
      <button onClick={(e) => handleCreateShift(e)}>Add Shift</button>
      {shiftsList}
    </div>
  );
}

export default ShiftForm;
