import os
import subprocess
from shutil import rmtree

from behave import *
from funcy import flatten
from hamcrest import assert_that, is_


@step('an empty "{target_dir}" directory')
def step_impl(context, target_dir):
    # Delete the directory recursively if it exists.
    if os.path.exists(target_dir):
        rmtree(target_dir)
    # Create the directory.
    os.makedirs(target_dir)


@step('I generate a new copy from the "{template}" template to the "{target_dir}" directory')
def step_impl(context, template, target_dir):
    context.execute_steps(u"""
      when I generate a new copy from the "{template}" template to the "{target_dir}" directory with the following values
      """.format(
        template=template,
        target_dir=target_dir,
    ))


@step('I generate a new copy from the "{template}" template to the "{target_dir}" directory with the following values')
def step_impl(context, template, target_dir):
    # The additional data to pass to the 'copier' command
    options = list(flatten(map(
        lambda row: ["--data", f"{row[0]}={row[1]}"],
        context.table.rows if context.table is not None else []
    )))
    # Generate the template skeleton using the 'copier' command
    command = [
        "copier", "copy", template, target_dir,
        *options,
        "--vcs-ref", "@latest",
        "--defaults", "--force", "--overwrite",
    ]
    subprocess.run(
        command,
        check=True,
        # stdout=subprocess.DEVNULL,
        # stderr=subprocess.DEVNULL
    )


@step('I run the tests in the "{target_dir}"')
def step_impl(context, target_dir):
    command = [
        "behave",
        "--exclude", "features/fixtures/.*",
        "--stop",
    ]
    result = subprocess.run(
        command,
        cwd=target_dir,
        capture_output=True,
        text=True,
    )

    assert_that(
        result.returncode, is_(0),
        'The return code of the "behave" command should be 0.\n\n' + \
        "Command:\n" + \
        " ".join(command) + "\n\n" + \
        "Command output:\n" + result.stdout
    )


@then('I move the "{source_dir}" directory to "{target_dir}"')
def step_impl(context, source_dir, target_dir):
    os.rename(source_dir, target_dir)


@step(
    'the contents of the "{target_dir}" directory should be the same as the contents in the "{reference_dir}" '
    'directory'
)
def step_impl(context, target_dir, reference_dir):
    context.execute_steps(u"""
        then the contents of the "{target_dir}" directory should be the same as the contents in the "{reference_dir}" directory with excludes
    """.format(
        target_dir=target_dir,
        reference_dir=reference_dir,
    ))


@step(
    'the contents of the "{target_dir}" directory should be the same as the contents in the "{reference_dir}" '
    'directory with excludes'
)
def step_impl(context, target_dir, reference_dir):
    # The additional data to pass to the 'diff' command
    options = list(map(
        lambda row: f"--exclude={row[0]}",
        context.table.rows if context.table is not None else []
    ))
    # Assert that the target directory exists
    assert_that(os.path.isdir(target_dir), is_(True), f"The target directory '{target_dir}' does not exist.")
    # Assert that the reference directory exists
    assert_that(os.path.isdir(reference_dir), is_(True), f"The reference directory '{reference_dir}' does not exist.")
    # Assert that the contents of the two directories are the same
    command = [
        "diff", target_dir, reference_dir,
        "--recursive",
        *options,
    ]
    result = subprocess.run(
        command,
        capture_output=True,
        text=True,
    )
    assert_that(
        result.returncode, is_(0),
        'The return code of the "diff" command should be 0.\n\n' + \
        "Workdir:\n" + \
        "--------\n" + \
        os.getcwd() + "\n\n" + \
        "Command:\n" + \
        "--------\n" + \
        " ".join(command) + "\n\n" + \
        "Command output:\n" + \
        "---------------\n" + \
        result.stdout + "\n\n"
    )
