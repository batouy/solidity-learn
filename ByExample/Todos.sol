// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "./StructDeclaration.sol";

struct Student {
    uint256 id;
    string name;
    Todo[] tasks;
}

contract StudentWithTodo {
    Student private student;
    Todo[] private tasks;

    function initStudent() public {
        student.id = 1;
        student.name = "John";

        tasks.push(Todo("M", false));
        tasks.push(Todo("T", true));

        student.tasks = tasks;
    }

    function getTodo() public view returns (Todo[] memory) {
        return student.tasks;
    }
}

struct User {
    uint256 balance;
    uint256 age;
}

contract Todos {
    Todo[] public todos;

    function create(string calldata _text) public {
        // 3 ways to initialize a struct
        todos.push(Todo(_text, false));

        todos.push(Todo({text: _text, completed: false}));

        Todo memory todo;
        todo.text = _text;
        todo.completed = false;
        todos.push(todo);
    }

    // Solidity automatically creates a getter for 'todos' so
    // you don't actually need this function.
    function get(uint256 _index) public view returns (string memory, bool) {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // When we declare dynamic data types we need to specify the location to store them
    function updateText(uint256 _index, string memory _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }

    mapping(address => User) public users;

    function updateUserAge(address userAddress, uint256 newAge) public {
        User memory user = users[userAddress]; // Load struct into memory

        user.age = newAge;

        users[userAddress] = user; // Write back to storage

        // [todo] VS: write into storage directly
        // users[userAddress].age = newAge;
    }
}
