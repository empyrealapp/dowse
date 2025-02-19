import asyncio

from dowse.dsl.executors.base import DowseExecutor, UserRequest

from .operators import SPECIAL_OPERATORS


async def amain():
    executor = DowseExecutor(
        special_operators=SPECIAL_OPERATORS,
    )

    code = await executor.solve(
        UserRequest(
            content="""
            Swap 0.001 ETH for $AERO, send 1/3 to @user2,
            then if a random number between 1 and 100 is greater than 35,
            send the rest to @user3
            """,
            username="@user1",
        ),
        max_errors=3,
        verbose=False,
    )
    code.print()


def main():
    asyncio.run(amain())


if __name__ == "__main__":
    main()
