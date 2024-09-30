"""
Test Custom Django Management Command.
"""

from unittest.mock import patch
# For mocking the behavior of database - simulate the db responses

from psycopg2 import OperationalError as Psycopg2Error
# One of the possible error that we can get
#   when we are trying to connevt to db, before the db is ready.

from django.core.management import call_command
# Help of func provided by django, that allow us to simulate call the command
from django.db.utils import OperationalError
# Another operational error (exception) that may be thrown by the db,
# depending on what stage of the start up process it is.
from django.test import SimpleTestCase
# Db not available,
# no need of migrations and all the things required for test database.


# patch for macking objects

@patch('core.management.commands.wait_for_db.Command.check')
class CommandTest(SimpleTestCase):
    """ Test Commands """

    def test_wait_for_db_ready(self, patched_check):
        # patched_check due to decorator.
        """ Test waiting for db if db is ready - One Test Case """
        patched_check.return_value = True

        call_command('wait_for_db')

        patched_check.assert_called_once_with(databases=['default'])

    @patch('time.sleep')
    def test_wait_for_db_delay(self, patched_sleep, patched_check):
        """ Test waiting for the database when getting operational error. """
        patched_check.side_effect = [Psycopg2Error] * 2 + \
            [OperationalError] * 3 + [True]
        # Here we just mocked the delay suiation -
        # Diff cases for 6 time is created.
        call_command('wait_for_db')

        self.assertEqual(patched_check.call_count, 6)
        patched_check.assert_called_with(databases=['default'])
