#!/bin/bash

# Function to generate conventional commit message
generate_commit_message() {
    local file="$1"
    local type=""
    local message=""

    case "$file" in
        LICENSE)
            type="docs"
            message="add project license"
            ;;
        README.md)
            type="docs"
            message="add project readme"
            ;;
        requirements.txt)
            type="build"
            message="add project dependencies"
            ;;
        "1-Python Basics/"*)
            type="feat(python-basics)"
            message="add Python basics content: ${file#1-Python Basics/}"
            ;;
        "2-Control Flow/"*)
            type="feat(control-flow)"
            message="add control flow content: ${file#2-Control Flow/}"
            ;;
        "3-Data Structures/"*)
            type="feat(data-structures)"
            message="add data structures content: ${file#3-Data Structures/}"
            ;;
        "4-Functions/"*)
            type="feat(functions)"
            message="add functions content: ${file#4-Functions/}"
            ;;
        "5-Modules/"*)
            type="feat(modules)"
            message="add modules content: ${file#5-Modules/}"
            ;;
        "6-File Handling/"*)
            type="feat(file-handling)"
            message="add file handling content: ${file#6-File Handling/}"
            ;;
        "7-Exception Handling/"*)
            type="feat(exception-handling)"
            message="add exception handling content: ${file#7-Exception Handling/}"
            ;;
        "8-Class And Objects/"*)
            type="feat(oop)"
            message="add OOP content: ${file#8-Class And Objects/}"
            ;;
        "9-Advance Python Concepts/"*)
            type="feat(advanced-python)"
            message="add advanced Python concepts: ${file#9-Advance Python Concepts/}"
            ;;
        "10-Data Analysis With Python/"*)
            type="feat(data-analysis)"
            message="add data analysis content: ${file#10-Data Analysis With Python/}"
            ;;
        "11-Working With Databases/"*)
            type="feat(databases)"
            message="add database content: ${file#11-Working With Databases/}"
            ;;
        "12-Logging In Python/"*)
            type="feat(logging)"
            message="add logging content: ${file#12-Logging In Python/}"
            ;;
        "13-Flask/"*)
            type="feat(flask)"
            message="add Flask content: ${file#13-Flask/}"
            ;;
        "14-Streamlit/"*)
            type="feat(streamlit)"
            message="add Streamlit content: ${file#14-Streamlit/}"
            ;;
        "15-Memory Management/"*)
            type="feat(memory-management)"
            message="add memory management content: ${file#15-Memory Management/}"
            ;;
        "16-Multithreading and Multiprocessing/"*)
            type="feat(concurrency)"
            message="add concurrency content: ${file#16-Multithreading and Multiprocessing/}"
            ;;
        *)
            type="chore"
            message="add ${file##*/}"
            ;;
    esac

    echo "${type}: ${message}"
}

# Function to check if git repository
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not a git repository. Please initialize git first."
        exit 1
    fi
}

# Function to commit and push changes recursively
commit_and_push_changes() {
    check_git_repo

    # Add LICENSE, README.md, and requirements.txt first
    local root_files=("LICENSE" "README.md" "requirements.txt")
    for file in "${root_files[@]}"; do
        if [ -f "$file" ]; then
            commit_message=$(generate_commit_message "$file")
            git add "$file"
            git commit -m "$commit_message"
            echo "Committed: $file with message - $commit_message"
        fi
    done

    # Directories to commit
    local directories=(
        "1-Python Basics"
        "2-Control Flow"
        "3-Data Structures"
        "4-Functions"
        "5-Modules"
        "6-File Handling"
        "7-Exception Handling"
        "8-Class And Objects"
        "9-Advance Python Concepts"
        "10-Data Analysis With Python"
        "11-Working With Databases"
        "12-Logging In Python"
        "13-Flask"
        "14-Streamlit"
        "15-Memory Management"
        "16-Multithreading and Multiprocessing"
    )

    # Commit directories recursively
    for dir in "${directories[@]}"; do
        if [ -d "$dir" ]; then
            # Find all files in the directory
            while IFS= read -r -d '' file; do
                relative_file="${file#./}"
                commit_message=$(generate_commit_message "$relative_file")
                git add "$relative_file"
                git commit -m "$commit_message"
                echo "Committed: $relative_file with message - $commit_message"
            done < <(find "$dir" -type f -print0)
        fi
    done

    # Push all changes
    git push origin master
    echo "All changes have been committed and pushed successfully!"
}

# Run the function
commit_and_push_changes