import { destroyPostAsync } from "./postSlice";

function ButtonGroup(props) {
  function handleClick(e) {
    const payload = {
      post: {
        post_id: props.post_id,
      },
    };
    props.dispatch(destroyPostAsync(payload));
  }
  return (
    <div>
      <button onClick={() => props.toggleEditForm()}>Edit</button>
      <button onClick={(e) => handleClick(e)}>Delete</button>
    </div>
  );
}

export default ButtonGroup;
