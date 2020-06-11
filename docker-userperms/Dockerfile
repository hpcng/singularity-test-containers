FROM alpine
MAINTAINER David Trudgian

# Create a directory, and put a file in it
RUN mkdir /testdir && touch /testdir/testfile

# Take away owner perms
RUN chmod 555 /testdir

# Remove the test file - should dissappear without issue
RUN rm /testdir/testfile

CMD find /testdir

